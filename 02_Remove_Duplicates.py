def remove_duplicates(s):
    result = ""
    
    for char in s:
        if char not in result:
            result += char
    
    return result


# Test cases
print(remove_duplicates("programming"))   # Output: progamin
print(remove_duplicates("hello"))         # Output: helo
print(remove_duplicates("aabbcc"))        # Output: abc
