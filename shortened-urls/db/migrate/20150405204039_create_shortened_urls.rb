class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :url
    end
    add_index :shortened_urls, :url
  end
end
