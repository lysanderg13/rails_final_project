ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :image, :category_id

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, collection: Category.all.map { |c| [c.category_name, c.id] }
    end
    f.inputs do
      f.input :image, as: :file,
                      hint: (f.object.image.attached? ? image_tag(f.object.image) : content_tag(:span, "No image available"))
    end
    f.actions
  end
end
