# -*- coding: utf-8 -*-

require 'Qt4'


module D3249
  module Widget

    ##This is a general use widget used to select items from a given list.
    #
    # There are two instances of QListWidget and 4 QPushButton.
    #
    # The button labeled ">>" adds the selected item of the left to the QListView on the right
    #
    # The button labeled "<<" removes the selected item of the right QListView
    #
    # The button labeled "Subir" moves up the selecetd item of the right QListView
    #
    # The button labeled "Bajar" moves down the selected item of the right QListView
    
    class ListSelector < Qt::Widget

      slots 'add_selected_item()','remove_selected_item()','move_selected_item_up()','move_selected_item_down()'

      # At creation a list must be given. These will be the items to choose from      
      def initialize(items_list, parent = nil)
        super parent
        @items_list = items_list
        init
      end

      public
      #Returns a list with all elements of the selected (rigth) QListView
      def selected
        result = []
        ##Debe haber una forma más ruby-like de hacer esto
        (0...@selected.count).each do |index|
         result << @selected.item(index).text
        end
        result
      end
      
      private
      def init
        
        @list = Qt::ListWidget.new

        @items_list.each do |item|
            @list.add_item(trUtf8(item))
        end
        connect(@list,SIGNAL('itemDoubleClicked(QListWidgetItem *)'),
                self,SLOT('add_selected_item()'))
                
        @selected = Qt::ListWidget.new
        connect(@selected,SIGNAL('itemDoubleClicked(QListWidgetItem *)'),
                self,SLOT('remove_selected_item()'))

        @add_b = Qt::PushButton.new(trUtf8('>>'))
        connect(@add_b,SIGNAL('clicked()'),
                self,SLOT('add_selected_item()'))
        
        @remove_b = Qt::PushButton.new(trUtf8('<<'))
        connect(@remove_b,SIGNAL('clicked()'),
                self,SLOT('remove_selected_item()'))

        @up_b = Qt::PushButton.new(trUtf8('Subir'))
        connect(@up_b,SIGNAL('clicked()'),
                self,SLOT('move_selected_item_up()'))

        @down_b = Qt::PushButton.new(trUtf8('Bajar'))
        connect(@down_b,SIGNAL('clicked()'),
                self,SLOT('move_selected_item_down()'))
        
        central_layout = Qt::VBoxLayout.new
        central_layout.add_widget(@add_b)
        central_layout.add_widget(@remove_b)

        right_layout = Qt::VBoxLayout.new
        right_layout.add_widget(@up_b)
        right_layout.add_widget(@down_b)
        
        layout = Qt::HBoxLayout.new

        layout.add_widget(@list)
        layout.add_layout(central_layout)
        layout.add_widget(@selected)
        layout.add_layout(right_layout)

        setLayout(layout)
      end

      public
      # [Qt signal] Adds selected item in the firsth QListView to the second one.
      def add_selected_item
        @selected.add_item(@list.selected_items[0].text)        
      end
      
      #[Qt signal] Removes the selected item from the second QListView
      def remove_selected_item
        @selected.take_item(@selected.row(@selected.selected_items[0]))
      end
      
      #[Qt signal] Moves the selected item in the second QListView one position up
      def move_selected_item_up
        position = @selected.row(@selected.selected_items[0])

        return if position <= 0

        new_position = position - 1
        
        item = @selected.take_item(position)
        @selected.insert_item(new_position,item)
        @selected.set_current_row(new_position)
      end
      
      #[Qt signal] Moves the selected item in the second QListView one position down
      def move_selected_item_down
        position = @selected.row(@selected.selected_items[0])

        return if position == -1 || position == @selected.count
        
        new_position = position + 1
        
        item = @selected.take_item(position)
        @selected.insert_item(new_position,item)
        @selected.set_current_row(new_position)
      end
      
    end
  end
end
      
