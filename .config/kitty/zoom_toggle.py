"""
This script toggles the layout of the active Window between the stack and the current layout.
"""

from kittens.tui.handler import result_handler
from kitty.boss import Boss


@result_handler(no_ui=True)
def handle_result(_args: list[str], _answer: str, _target_window_id: int, boss: Boss) -> None:
    """
    Implements the toggling of the layout.
    """
    tab = boss.active_tab
    if tab is not None:
        if tab.current_layout.name == "stack":
            tab.last_used_layout()
        else:
            tab.goto_layout("stack")


def main(args: list[str]) -> str:
    """
    Mainline does nothing, but still needs to be defined.
    """
