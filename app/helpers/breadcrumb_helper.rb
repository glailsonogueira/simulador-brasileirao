module BreadcrumbHelper
  def breadcrumb(*links)
    content_tag :nav, class: 'breadcrumb', style: 'background: white; padding: 15px 20px; margin-bottom: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);' do
      items = links.map do |link|
        if link.is_a?(Array)
          link_to link[0], link[1], style: 'color: #0066cc; text-decoration: none;'
        else
          content_tag :span, link, style: 'color: #666;'
        end
      end
      
      safe_join(items, content_tag(:span, ' / ', style: 'margin: 0 10px; color: #999;'))
    end
  end
end
