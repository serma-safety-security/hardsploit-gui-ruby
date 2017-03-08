=begin
** Form generated from reading ui file 'gui_generic_commands.ui'
**
** Created: mer. mars 8 11:15:04 2017
**      by: Qt User Interface Compiler version 4.8.7
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Generic_commands
    attr_reader :actionExecute
    attr_reader :actionEdit
    attr_reader :actionTemplate
    attr_reader :actionDelete
    attr_reader :actionConcatenate
    attr_reader :centralwidget
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
    attr_reader :label
    attr_reader :hl3
    attr_reader :check_result
    attr_reader :hs2
    attr_reader :btn_new_cmd
    attr_reader :menubar
    attr_reader :menuCommandes
    attr_reader :statusbar

    def setupUi(generic_commands)
    if generic_commands.objectName.nil?
        generic_commands.objectName = "generic_commands"
    end
    generic_commands.windowModality = Qt::ApplicationModal
    generic_commands.resize(542, 383)
    @actionExecute = Qt::Action.new(generic_commands)
    @actionExecute.objectName = "actionExecute"
    @actionEdit = Qt::Action.new(generic_commands)
    @actionEdit.objectName = "actionEdit"
    @actionTemplate = Qt::Action.new(generic_commands)
    @actionTemplate.objectName = "actionTemplate"
    @actionDelete = Qt::Action.new(generic_commands)
    @actionDelete.objectName = "actionDelete"
    @actionConcatenate = Qt::Action.new(generic_commands)
    @actionConcatenate.objectName = "actionConcatenate"
    @centralwidget = Qt::Widget.new(generic_commands)
    @centralwidget.objectName = "centralwidget"
    @gridLayout = Qt::GridLayout.new(@centralwidget)
    @gridLayout.objectName = "gridLayout"
    @vl = Qt::VBoxLayout.new()
    @vl.objectName = "vl"
    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @lbl_search = Qt::Label.new(@centralwidget)
    @lbl_search.objectName = "lbl_search"

    @hl.addWidget(@lbl_search)

    @lie_search = Qt::LineEdit.new(@centralwidget)
    @lie_search.objectName = "lie_search"
    @lie_search.maxLength = 10

    @hl.addWidget(@lie_search)

    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @lbl_current_chip = Qt::Label.new(@centralwidget)
    @lbl_current_chip.objectName = "lbl_current_chip"

    @hl.addWidget(@lbl_current_chip)

    @lbl_chip = Qt::Label.new(@centralwidget)
    @lbl_chip.objectName = "lbl_chip"

    @hl.addWidget(@lbl_chip)


    @vl.addLayout(@hl)

    @vl2 = Qt::VBoxLayout.new()
    @vl2.objectName = "vl2"
    @tbl_cmd = Qt::TableWidget.new(@centralwidget)
    @tbl_cmd.objectName = "tbl_cmd"
    @font = Qt::Font.new
    @font.family = "Arial"
    @tbl_cmd.font = @font
    @tbl_cmd.sortingEnabled = true

    @vl2.addWidget(@tbl_cmd)

    @label = Qt::Label.new(@centralwidget)
    @label.objectName = "label"

    @vl2.addWidget(@label)

    @hl3 = Qt::HBoxLayout.new()
    @hl3.objectName = "hl3"
    @check_result = Qt::CheckBox.new(@centralwidget)
    @check_result.objectName = "check_result"
    @check_result.checked = true

    @hl3.addWidget(@check_result)

    @hs2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl3.addItem(@hs2)

    @btn_new_cmd = Qt::PushButton.new(@centralwidget)
    @btn_new_cmd.objectName = "btn_new_cmd"

    @hl3.addWidget(@btn_new_cmd)


    @vl2.addLayout(@hl3)


    @vl.addLayout(@vl2)


    @gridLayout.addLayout(@vl, 0, 0, 1, 1)

    generic_commands.centralWidget = @centralwidget
    @menubar = Qt::MenuBar.new(generic_commands)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 542, 21)
    @menuCommandes = Qt::Menu.new(@menubar)
    @menuCommandes.objectName = "menuCommandes"
    generic_commands.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(generic_commands)
    @statusbar.objectName = "statusbar"
    generic_commands.statusBar = @statusbar

    @menubar.addAction(@menuCommandes.menuAction())
    @menuCommandes.addAction(@actionExecute)
    @menuCommandes.addAction(@actionEdit)
    @menuCommandes.addAction(@actionTemplate)
    @menuCommandes.addAction(@actionDelete)
    @menuCommandes.addAction(@actionConcatenate)

    retranslateUi(generic_commands)
    Qt::Object.connect(@lie_search, SIGNAL('textChanged(QString)'), generic_commands, SLOT('feed_cmd_array()'))
    Qt::Object.connect(@btn_new_cmd, SIGNAL('clicked()'), generic_commands, SLOT('create()'))
    Qt::Object.connect(@actionExecute, SIGNAL('triggered()'), generic_commands, SLOT('execute()'))
    Qt::Object.connect(@actionEdit, SIGNAL('triggered()'), generic_commands, SLOT('edit()'))
    Qt::Object.connect(@actionDelete, SIGNAL('triggered()'), generic_commands, SLOT('delete()'))
    Qt::Object.connect(@actionTemplate, SIGNAL('triggered()'), generic_commands, SLOT('template()'))
    Qt::Object.connect(@actionConcatenate, SIGNAL('triggered()'), generic_commands, SLOT('concatenate()'))

    Qt::MetaObject.connectSlotsByName(generic_commands)
    end # setupUi

    def setup_ui(generic_commands)
        setupUi(generic_commands)
    end

    def retranslateUi(generic_commands)
    generic_commands.windowTitle = Qt::Application.translate("Generic_commands", "Hardsploit - Commands", nil, Qt::Application::UnicodeUTF8)
    @actionExecute.text = Qt::Application.translate("Generic_commands", "Execute", nil, Qt::Application::UnicodeUTF8)
    @actionEdit.text = Qt::Application.translate("Generic_commands", "Edit", nil, Qt::Application::UnicodeUTF8)
    @actionTemplate.text = Qt::Application.translate("Generic_commands", "Template", nil, Qt::Application::UnicodeUTF8)
    @actionDelete.text = Qt::Application.translate("Generic_commands", "Delete", nil, Qt::Application::UnicodeUTF8)
    @actionConcatenate.text = Qt::Application.translate("Generic_commands", "Concatenate", nil, Qt::Application::UnicodeUTF8)
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
    @label.text = Qt::Application.translate("Generic_commands", "Right click on a command to open the menu", nil, Qt::Application::UnicodeUTF8)
    @check_result.text = Qt::Application.translate("Generic_commands", "Show command result", nil, Qt::Application::UnicodeUTF8)
    @btn_new_cmd.text = Qt::Application.translate("Generic_commands", "New Command", nil, Qt::Application::UnicodeUTF8)
    @menuCommandes.title = Qt::Application.translate("Generic_commands", "Commandes...", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(generic_commands)
        retranslateUi(generic_commands)
    end

end

module Ui
    class Generic_commands < Ui_Generic_commands
    end
end  # module Ui

