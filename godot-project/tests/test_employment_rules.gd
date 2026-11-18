extends SceneTree

const GameScript = preload("res://scripts/main.gd")
const EXPECTED_CHECKS := 53

var checks: int = 0
var failures: int = 0

func _initialize() -> void:
    call_deferred("_run_tests")

func _run_tests() -> void:
    _test_shift_window_boundaries()
    _test_normal_shift_and_daily_limit()
    _test_noon_boundary()
    _test_rejected_shift_conditions()
    _test_job_application()
    _test_job_catalog()
    _test_all_salary_payouts()
    _test_minimum_energy_boundary()
    _test_invalid_job_application()

    if checks != EXPECTED_CHECKS:
        failures += 1
        push_error("Expected %d checks, but executed %d." % [EXPECTED_CHECKS, checks])

    if failures == 0:
        print("EMPLOYMENT_TESTS: PASS (%d checks)" % checks)
        quit(0)
    else:
        push_error("EMPLOYMENT_TESTS: FAIL (%d failures across %d checks)" % [failures, checks])
        quit(1)

func _new_game():
    var game = GameScript.new()
    # Unit tests must never touch a real user:// save file.
    game.save_locked_for_newer_version = true
    return game

func _check(condition: bool, description: String) -> void:
    checks += 1
    if condition:
        print("PASS: " + description)
    else:
        failures += 1
        push_error("FAIL: " + description)

func _test_shift_window_boundaries() -> void:
    var game = _new_game()
    var cases: Array[Dictionary] = [
        {"hour": 5, "minute": 59, "expected": false, "label": "05:59 rejected"},
        {"hour": 6, "minute": 0, "expected": true, "label": "06:00 accepted"},
        {"hour": 6, "minute": 1, "expected": true, "label": "06:01 accepted"},
        {"hour": 11, "minute": 59, "expected": true, "label": "11:59 accepted"},
        {"hour": 12, "minute": 0, "expected": true, "label": "12:00 accepted"},
        {"hour": 12, "minute": 1, "expected": false, "label": "12:01 rejected"},
        {"hour": 12, "minute": 59, "expected": false, "label": "12:59 rejected"},
        {"hour": 13, "minute": 0, "expected": false, "label": "13:00 rejected"},
        {"hour": 23, "minute": 59, "expected": false, "label": "23:59 rejected"}
    ]
    for test_case in cases:
        game.hour = int(test_case["hour"])
        game.minute = int(test_case["minute"])
        _check(
            game._is_work_start_time() == bool(test_case["expected"]),
            str(test_case["label"])
        )

func _test_normal_shift_and_daily_limit() -> void:
    var game = _new_game()
    game.current_job_id = "shop_assistant"
    game.day = 1
    game.hour = 6
    game.minute = 0
    game.money = 30000
    game.energy = 100
    game.mood = 80

    game._start_work_shift()
    _check(game.hour == 14 and game.minute == 0 and game.day == 1, "06:00 shift ends at 14:00")
    _check(game.money == 32200, "shop assistant salary is added exactly once")
    _check(game.energy == 65 and game.mood == 77, "shift applies expected energy and mood costs")
    _check(game.shifts_completed == 1 and game.last_shift_day == 1, "shift counters are updated")

    game._start_work_shift()
    _check(game.money == 32200 and game.shifts_completed == 1, "second shift on same day is rejected")

    game.day = 2
    game.hour = 6
    game.minute = 0
    game._start_work_shift()
    _check(game.money == 34400 and game.shifts_completed == 2, "next day allows one new shift")

func _test_noon_boundary() -> void:
    var game = _new_game()
    game.current_job_id = "warehouse_worker"
    game.day = 1
    game.hour = 12
    game.minute = 0
    game.energy = 100
    game._start_work_shift()
    _check(game.hour == 20 and game.minute == 0, "12:00 is the final accepted start time")
    _check(game.money == 33000, "noon shift pays the correct warehouse salary")

func _test_rejected_shift_conditions() -> void:
    var no_job = _new_game()
    no_job.hour = 8
    no_job._start_work_shift()
    _check(no_job.money == 30000 and no_job.shifts_completed == 0, "shift without a job is rejected")

    var late = _new_game()
    late.current_job_id = "shop_assistant"
    late.hour = 12
    late.minute = 1
    late._start_work_shift()
    _check(late.money == 30000 and late.hour == 12 and late.minute == 1, "12:01 shift attempt changes no money or time")

    var tired = _new_game()
    tired.current_job_id = "shop_assistant"
    tired.hour = 8
    tired.energy = 24
    tired._start_work_shift()
    _check(tired.money == 30000 and tired.shifts_completed == 0, "energy below 25 rejects shift")

    var unknown = _new_game()
    unknown.current_job_id = "missing_job"
    unknown.hour = 8
    unknown._start_work_shift()
    _check(unknown.money == 30000 and unknown.shifts_completed == 0, "unknown job identifier is rejected")

func _test_job_application() -> void:
    var game = _new_game()
    game.hour = 8
    game.minute = 0
    game._apply_for_job("cafe_helper")
    _check(game.current_job_id == "cafe_helper", "successful interview assigns selected job")
    _check(game.hour == 8 and game.minute == 30, "interview consumes 30 in-game minutes")
    _check(game.energy == 95 and game.current_screen == "work", "interview updates energy and opens work screen")

    game._apply_for_job("warehouse_worker")
    _check(game.current_job_id == "cafe_helper", "second job cannot replace an active job without quitting")
    _check(game.hour == 8 and game.minute == 30, "rejected second application consumes no time")
    _check(game.energy == 95, "rejected second application consumes no energy")

func _test_job_catalog() -> void:
    var game = _new_game()
    var expected_salaries: Dictionary = {
        "shop_assistant": 2200,
        "warehouse_worker": 3000,
        "cleaner": 1900,
        "cafe_helper": 2400
    }
    for job_id in expected_salaries:
        var job: Dictionary = game._get_job(str(job_id))
        _check(not job.is_empty(), "%s exists in the vacancy catalog" % str(job_id))
        _check(
            int(job.get("salary", 0)) == int(expected_salaries[job_id]),
            "%s has the documented salary" % str(job_id)
        )

func _test_all_salary_payouts() -> void:
    var cases: Array[Dictionary] = [
        {"id": "shop_assistant", "salary": 2200},
        {"id": "warehouse_worker", "salary": 3000},
        {"id": "cleaner", "salary": 1900},
        {"id": "cafe_helper", "salary": 2400}
    ]
    for test_case in cases:
        var game = _new_game()
        game.current_job_id = str(test_case["id"])
        game.hour = 8
        game.minute = 0
        game._start_work_shift()
        var salary := int(test_case["salary"])
        var job_id := str(test_case["id"])
        _check(game.money == 30000 + salary, "%s credits the exact salary" % job_id)
        _check(game.total_earned == salary, "%s updates lifetime earnings" % job_id)
        _check(game.shifts_completed == 1, "%s increments the shift counter once" % job_id)

func _test_minimum_energy_boundary() -> void:
    var game = _new_game()
    game.current_job_id = "cleaner"
    game.hour = 8
    game.energy = 25
    game._start_work_shift()
    _check(game.shifts_completed == 1, "exactly 25 energy is sufficient to start")
    _check(game.energy == 0, "minimum-energy shift consumes 35 without going negative")
    _check(game.money == 31900, "minimum-energy shift still pays the cleaner salary")

func _test_invalid_job_application() -> void:
    var game = _new_game()
    game.hour = 8
    game.minute = 10
    game._apply_for_job("missing_job")
    _check(game.current_job_id.is_empty(), "unknown vacancy does not assign a job")
    _check(game.hour == 8 and game.minute == 10, "unknown vacancy consumes no interview time")
    _check(game.energy == 100, "unknown vacancy consumes no energy")
