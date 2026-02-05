class CapsNumLockIndicator(base.ThreadPoolText):
    """Really simple widget to show the current Caps/Num Lock state."""
    defaults = [("update_interval", 0.5, "Update Time in seconds.")]

    def __init__(self, **config):
        base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(CapsNumLockIndicator.defaults)

    def get_indicators(self):
        """Return a list with the current state of the keys."""
        try:
            output = self.call_process(["xset", "q"])
        except subprocess.CalledProcessError as err:
            output = err.output
            return []
        if output.startswith("Keyboard"):
            indicators = re.findall(r"(Caps|Num)\s+Lock:\s*(\w*)", output)
            return indicators

    def is_indicator_on_icon(self, indicator):
        """Return True if the indicator is on."""
        is_indicator_on = (indicator[1] == "on")
        return "" if is_indicator_on else ""
    def poll(self):
        """Poll content for the text box."""
        indicators = self.get_indicators()
        status = f"A{self.is_indicator_on_icon(indicators[0])} 1{self.is_indicator_on_icon(indicators[1])}"
        return status
