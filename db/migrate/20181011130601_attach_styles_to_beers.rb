class AttachStylesToBeers < ActiveRecord::Migration[5.2]
  def up
    Beer.all.map{ |b| b['old_style'] }.uniq.each do |style|
      s = Style.find_by name: style
      Style.create name: style if s.nil?
    end

    Beer.all.each do |b|
      style = Style.find_by name: b['old_style']
      b.style = style 
      b.save
    end

    remove_column :beers, :old_style
  end
end
