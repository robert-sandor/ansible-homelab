def to_toml(obj):
    import tomli_w

    return tomli_w.dumps(obj)


class FilterModule(object):
    def filters(self):
        return {
            "to_toml": to_toml,
        }
