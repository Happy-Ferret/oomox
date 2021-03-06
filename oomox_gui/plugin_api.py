from abc import ABCMeta, abstractproperty, abstractmethod
from enum import Enum

from oomox_gui.config import FALLBACK_COLOR


class OomoxPlugin(metaclass=ABCMeta):

    @abstractproperty
    def name(self):
        pass

    @abstractproperty
    def display_name(self):
        pass


class OomoxThemePlugin(OomoxPlugin):

    @abstractproperty
    def description(self):
        pass

    @abstractproperty
    def export_dialog(self):
        pass

    @abstractproperty
    def gtk_preview_dir(self):
        pass

    enabled_keys_gtk = []
    enabled_keys_options = []
    enabled_keys_other = []
    enabled_keys_extra = []

    theme_model_gtk = []
    theme_model_options = []
    theme_model_other = []
    theme_model_extra = []

    def preview_before_load_callback(self, preview_object, colorscheme):
        pass

    class PreviewImageboxesNames(Enum):
        CHECKBOX = 'checkbox-checked'

    preview_sizes = {
        PreviewImageboxesNames.CHECKBOX.name: 16,
    }

    def preview_transform_function(self, svg_template, colorscheme):
        # pylint: disable=no-self-use
        for key in (
                "SEL_BG", "ACCENT_BG", "TXT_BG", "BG", "FG",
        ):
            svg_template = svg_template.replace(
                "%{}%".format(key), colorscheme.get(key) or FALLBACK_COLOR
            )
        return svg_template


class OomoxIconsPlugin(OomoxPlugin):

    enabled_keys_icons = []
    theme_model_icons = []

    @abstractproperty
    def preview_svg_dir(self):
        pass

    @abstractmethod
    def preview_transform_function(self, svg_template, colorscheme):
        pass


class OomoxExportPlugin(OomoxPlugin):

    @abstractproperty
    def export_dialog(self):
        pass

    theme_model_extra = []


class OomoxImportPlugin(OomoxPlugin):

    # @abstractproperty
    # def import_dialog(self):
        # pass

    @abstractproperty
    def file_extensions(self):
        pass

    @abstractmethod
    def read_colorscheme_from_path(self, preset_path):
        pass

    theme_model_import = []
