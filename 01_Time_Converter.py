def convert_minutes(minutes):
    hours = minutes // 60
    mins = minutes % 60

    if hours > 0:
        if hours == 1:
            return f"{hours} hr {mins} minutes"
        else:
            return f"{hours} hrs {mins} minutes"
    else:
        return f"{mins} minutes"


# Test cases
print(convert_minutes(130))  # Output: 2 hrs 10 minutes
print(convert_minutes(110))  # Output: 1 hr 50 minutes
print(convert_minutes(45))   # Output: 45 minutes
