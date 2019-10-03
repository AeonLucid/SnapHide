// From https://stackoverflow.com/a/744822.
int32_t ends_with(const char *str, const char *suffix) {
    if (str == 0 || suffix == 0) {
        return 0;
    }

    size_t len_str = strlen(str);
    size_t len_suffix = strlen(suffix);

    if (len_suffix > len_str) {
        return 0;
    }

    return strncmp(str + len_str - len_suffix, suffix, len_suffix) == 0;
}