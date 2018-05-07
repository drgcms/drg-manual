namespace :drg_cms do
  desc "Convert old drg_books format to drg_manual"
  task :book_to_manual => :environment do
    DcBook.all.each do |book|
      manual = DcManual.new(
        title: book.title,
        description: book.description,
        author: book.author
      )
      manual.save
#
      top_page = nil
      DcBookChapter.where(dc_book_id: book.id).order_by(chapter: 1).each do |chapter|
        order = chapter.chapter.split('.')
        page  = DcManualPage.new(
          title: chapter.title,
          body: chapter.dc_book_texts.first.body
        )
        if order.size == 1
          page.order = order.first.to_i*10
          manual.dc_manual_pages << page
          top_page = page
        else  
          page.order = order.last.to_i*10
          top_page.dc_manual_pages << page
        end
      end     
      
    end
  end
end