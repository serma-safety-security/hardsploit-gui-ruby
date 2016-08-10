=begin
** Form generated from reading ui file 'gui_progress_bar.ui'
**
** Created: mar. juil. 12 16:05:25 2016
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Progress_bar
    attr_reader :gridLayout
    attr_reader :lbl_status
    attr_reader :pgb
    attr_reader :horizontalLayout
    attr_reader :lbl_time
    attr_reader :horizontalSpacer
    attr_reader :lbl_close

    def setupUi(progress_bar)
    if progress_bar.objectName.nil?
        progress_bar.objectName = "progress_bar"
    end
    progress_bar.windowModality = Qt::ApplicationModal
    progress_bar.resize(358, 90)
    @gridLayout = Qt::GridLayout.new(progress_bar)
    @gridLayout.objectName = "gridLayout"
    @lbl_status = Qt::Label.new(progress_bar)
    @lbl_status.objectName = "lbl_status"

    @gridLayout.addWidget(@lbl_status, 0, 0, 1, 1)

    @pgb = Qt::ProgressBar.new(progress_bar)
    @pgb.objectName = "pgb"
    @pgb.value = 0

    @gridLayout.addWidget(@pgb, 1, 0, 1, 1)

    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @lbl_time = Qt::Label.new(progress_bar)
    @lbl_time.objectName = "lbl_time"

    @horizontalLayout.addWidget(@lbl_time)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout.addItem(@horizontalSpacer)

    @lbl_close = Qt::PushButton.new(progress_bar)
    @lbl_close.objectName = "lbl_close"

    @horizontalLayout.addWidget(@lbl_close)


    @gridLayout.addLayout(@horizontalLayout, 3, 0, 1, 1)


    retranslateUi(progress_bar)
    Qt::Object.connect(@lbl_close, SIGNAL('clicked()'), progress_bar, SLOT('close()'))

    Qt::MetaObject.connectSlotsByName(progress_bar)
    end # setupUi

    def setup_ui(progress_bar)
        setupUi(progress_bar)
    end

    def retranslateUi(progress_bar)
    progress_bar.windowTitle = Qt::Application.translate("Progress_bar", "Processing...", nil, Qt::Application::UnicodeUTF8)
    @lbl_status.text = Qt::Application.translate("Progress_bar", "[STATUS]", nil, Qt::Application::UnicodeUTF8)
    @lbl_time.text = Qt::Application.translate("Progress_bar", "[TIME]", nil, Qt::Application::UnicodeUTF8)
    @lbl_close.text = Qt::Application.translate("Progress_bar", "Close", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(progress_bar)
        retranslateUi(progress_bar)
    end

end

module Ui
    class Progress_bar < Ui_Progress_bar
    end
end  # module Ui

