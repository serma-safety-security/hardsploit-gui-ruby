=begin
** Form generated from reading ui file 'gui_i2c_command.ui'
**
** Created: jeu. mai 26 15:30:17 2016
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_I2c_command
    attr_reader :gridLayout
    attr_reader :fl
    attr_reader :lbl_size
    attr_reader :lie_size
    attr_reader :lbl_type_cmd
    attr_reader :groupBox
    attr_reader :rbn_read
    attr_reader :rbn_write
    attr_reader :hl
    attr_reader :hs
    attr_reader :btn_cancel
    attr_reader :bnt_new_cmd

    def setupUi(i2c_command)
    if i2c_command.objectName.nil?
        i2c_command.objectName = "i2c_command"
    end
    i2c_command.windowModality = Qt::ApplicationModal
    i2c_command.resize(287, 103)
    @gridLayout = Qt::GridLayout.new(i2c_command)
    @gridLayout.objectName = "gridLayout"
    @fl = Qt::FormLayout.new()
    @fl.objectName = "fl"
    @lbl_size = Qt::Label.new(i2c_command)
    @lbl_size.objectName = "lbl_size"

    @fl.setWidget(0, Qt::FormLayout::LabelRole, @lbl_size)

    @lie_size = Qt::LineEdit.new(i2c_command)
    @lie_size.objectName = "lie_size"

    @fl.setWidget(0, Qt::FormLayout::FieldRole, @lie_size)

    @lbl_type_cmd = Qt::Label.new(i2c_command)
    @lbl_type_cmd.objectName = "lbl_type_cmd"

    @fl.setWidget(1, Qt::FormLayout::LabelRole, @lbl_type_cmd)

    @groupBox = Qt::GroupBox.new(i2c_command)
    @groupBox.objectName = "groupBox"
    @rbn_read = Qt::RadioButton.new(@groupBox)
    @rbn_read.objectName = "rbn_read"
    @rbn_read.geometry = Qt::Rect.new(10, -4, 61, 31)
    @rbn_read.checked = true
    @rbn_write = Qt::RadioButton.new(@groupBox)
    @rbn_write.objectName = "rbn_write"
    @rbn_write.geometry = Qt::Rect.new(90, 0, 61, 21)

    @fl.setWidget(1, Qt::FormLayout::FieldRole, @groupBox)


    @gridLayout.addLayout(@fl, 1, 0, 1, 1)

    @hl = Qt::HBoxLayout.new()
    @hl.objectName = "hl"
    @hs = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @hl.addItem(@hs)

    @btn_cancel = Qt::PushButton.new(i2c_command)
    @btn_cancel.objectName = "btn_cancel"

    @hl.addWidget(@btn_cancel)

    @bnt_new_cmd = Qt::PushButton.new(i2c_command)
    @bnt_new_cmd.objectName = "bnt_new_cmd"

    @hl.addWidget(@bnt_new_cmd)


    @gridLayout.addLayout(@hl, 2, 0, 1, 1)


    retranslateUi(i2c_command)
    Qt::Object.connect(@btn_cancel, SIGNAL('clicked()'), i2c_command, SLOT('close()'))
    Qt::Object.connect(@bnt_new_cmd, SIGNAL('clicked()'), i2c_command, SLOT('open_generic_cmd()'))

    Qt::MetaObject.connectSlotsByName(i2c_command)
    end # setupUi

    def setup_ui(i2c_command)
        setupUi(i2c_command)
    end

    def retranslateUi(i2c_command)
    i2c_command.windowTitle = Qt::Application.translate("I2c_command", "Hardsploit - I2C Command", nil, Qt::Application::UnicodeUTF8)
    @lbl_size.text = Qt::Application.translate("I2c_command", "Payload size:", nil, Qt::Application::UnicodeUTF8)
    @lbl_type_cmd.text = Qt::Application.translate("I2c_command", "Command type:", nil, Qt::Application::UnicodeUTF8)
    @groupBox.title = ''
    @rbn_read.text = Qt::Application.translate("I2c_command", "Read", nil, Qt::Application::UnicodeUTF8)
    @rbn_write.text = Qt::Application.translate("I2c_command", "Write", nil, Qt::Application::UnicodeUTF8)
    @btn_cancel.text = Qt::Application.translate("I2c_command", "Cancel", nil, Qt::Application::UnicodeUTF8)
    @bnt_new_cmd.text = Qt::Application.translate("I2c_command", "Open", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(i2c_command)
        retranslateUi(i2c_command)
    end

end

module Ui
    class I2c_command < Ui_I2c_command
    end
end  # module Ui

