=begin
** Form generated from reading ui file 'gui_generic_commands.ui'
**
** Created: jeu. déc. 3 15:41:54 2015
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Generic_commands
    attr_reader :gridLayout
    attr_reader :vl
    attr_reader :hl
    attr_reader :lbl_search
    attr_reader :lie_search
    attr_reader :hs
    attr_reader :lbl_current_chip
    attr_reader :lbl_chip
    attr_reader :vl2
    attr_reader :tbl_cmd
    attr_reader :hl3
    attr_reader :check_result
    attr_reader :hs2
    attr_reader :btn_new_cmd
    attr_reader :cbx_action
    attr_reader :btn_next

    def setupUi(generic_commands)
    if generic_commands.objectName.nil?
        generic_commands.objectName = "generic_commands"
    end
    generic_commands.resize(532, 384)
    generic_commands.minimumSize = Qt::Size.new(532, 384)
    @gridLayout = Qt::GridLayout.new(generic_commands)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @lbl_search = Qt::Label.new(generic_commands)
    @lbl_search.objectName = "lbl_search"

    @hl.addWidget(@lbl_search)

    @lie_search = Qt::LineEdit.new(generic_commands)
    @lie_search.objectName = "lie_search"
    @lie_search.maxLength = 10

    @hl.addWidget(@lie_search)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @lbl_current_chip = Qt::Label.new(generic_commands)
    @lbl_current_chip.objectName = "lbl_current_chip"

    @hl.addWidget(@lbl_current_chip)

    @lbl_chip = Qt::Label.new(generic_commands)
    @lbl_chip.objectName = "lbl_chip"

    @hl.addWidget(@lbl_chip)


    @vl.addLayout(@hl)

    @vl2 = Qt::VBoxLayout.new()
    @vl2.objectName = "vl2"
    @tbl_cmd = Qt::TableWidget.new(generic_commands)
    @tbl_cmd.objectName = "tbl_cmd"
    @font = Qt::Font.new
    @font.family = "Arial"
    @tbl_cmd.font = @font
    @tbl_cmd.sortingEnabled = true

    @vl2.addWidget(@tbl_cmd)

    @hl3 = Qt::HBoxLayout.new()
    @hl3.objectName = "hl3"
    @check_result = Qt::CheckBox.new(generic_commands)
    @check_result.objectName = "check_result"

    @hl3.addWidget(@check_result)

    @hs2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl3.addItem(@hs2)

    @btn_new_cmd = Qt::PushButton.new(generic_commands)
    @btn_new_cmd.objectName = "btn_new_cmd"

    @hl3.addWidget(@btn_new_cmd)

    @cbx_action = Qt::ComboBox.new(generic_commands)
    @cbx_action.objectName = "cbx_action"

    @hl3.addWidget(@cbx_action)

    @btn_next = Qt::PushButton.new(generic_commands)
    @btn_next.objectName = "btn_next"

    @hl3.addWidget(@btn_next)


    @vl2.addLayout(@hl3)


    @vl.addLayout(@vl2)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)


    retranslateUi(generic_commands)
    Qt::Object.connect(@lie_search, SIGNAL('textChanged(QString)'), generic_commands, SLOT('feed_cmd_array()'))
    Qt::Object.connect(@btn_new_cmd, SIGNAL('clicked()'), generic_commands, SLOT('open_cmd_form()'))
    Qt::Object.connect(@btn_next, SIGNAL('clicked()'), generic_commands, SLOT('exec_action()'))

    Qt::MetaObject.connectSlotsByName(generic_commands)
    end # setupUi

    def setup_ui(generic_commands)
        setupUi(generic_commands)
    end

    def retranslateUi(generic_commands)
    generic_commands.windowTitle = Qt::Application.translate("Generic_commands", "Hardsploit - Commands", nil, Qt::Application::UnicodeUTF8)
    @lbl_search.text = Qt::Application.translate("Generic_commands", "Search", nil, Qt::Application::UnicodeUTF8)
    @lie_search.inputMask = ''
    @lbl_current_chip.text = Qt::Application.translate("Generic_commands", "Current chip:", nil, Qt::Application::UnicodeUTF8)
    @lbl_chip.text = Qt::Application.translate("Generic_commands", "[CHIP]", nil, Qt::Application::UnicodeUTF8)
    if @tbl_cmd.columnCount < 2
        @tbl_cmd.columnCount = 2
    end

    __colItem = Qt::TableWidgetItem.new
    __colItem.setText(Qt::Application.translate("Generic_commands", "Name", nil, Qt::Application::UnicodeUTF8))
    @tbl_cmd.setHorizontalHeaderItem(0, __colItem)

    __colItem1 = Qt::TableWidgetItem.new
    __colItem1.setText(Qt::Application.translate("Generic_commands", "Description", nil, Qt::Application::UnicodeUTF8))
    @tbl_cmd.setHorizontalHeaderItem(1, __colItem1)
    @check_result.text = Qt::Application.translate("Generic_commands", "Show command result", nil, Qt::Application::UnicodeUTF8)
    @btn_new_cmd.text = Qt::Application.translate("Generic_commands", "New Command", nil, Qt::Application::UnicodeUTF8)
    @cbx_action.insertItems(0, [Qt::Application.translate("Generic_commands", "Action...", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Generic_commands", "Execute", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Generic_commands", "Edit", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Generic_commands", "Delete", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Generic_commands", "Template", nil, Qt::Application::UnicodeUTF8)])
    @btn_next.text = Qt::Application.translate("Generic_commands", "Next", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(generic_commands)
        retranslateUi(generic_commands)
    end

end

module Ui
    class Generic_commands < Ui_Generic_commands
    end
end  # module Ui

