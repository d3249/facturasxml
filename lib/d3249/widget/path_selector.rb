# -*- coding: utf-8 -*-

require 'Qt4'

module D3249
  module Widget

    #This is a general porpuse Qt4 widget to choose a path to a directory.
    class PathSelector < Qt::Widget

      slots 'browse()'

      #Initializes the widget
      def initialize(parent = nil)
        super
        init
      end

      private
      def init
        
        @line_editor = Qt::LineEdit.new

        @browse_b = Qt::PushButton.new(tr('Explorar'))
        connect(@browse_b,SIGNAL('clicked()'),
                self,SLOT('browse()'))
        
        layout = Qt::HBoxLayout.new

        layout.add_widget(@line_editor)
        layout.add_widget(@browse_b)

        set_layout(layout)
      end

      public
      # [Qt signal] Brings up the file dialog to select the path.
      #
      # It tries to open the path in the QLineEdit or, if imposible, the $HOME directory
      def browse

        path = @line_editor.text

        path = system("echo $HOME") if path == ""

        path = Qt::FileDialog.get_existing_directory(self,tr('Abrir Carpeta'),path,Qt::FileDialog::ShowDirsOnly)

        @line_editor.set_text(path)        
      end

      #Returns the content of the QLineEdit in the widget
      def path
        @line_editor.text
      end
    end

  end
end
