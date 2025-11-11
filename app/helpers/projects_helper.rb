module ProjectsHelper
  def status_badge_color(status)
    {
      "planning" => "bg-blue-500",
      "active" => "bg-green-500",
      "on_hold" => "bg-yellow-500",
      "completed" => "bg-gray-500"
    }[status] || "bg-gray-500"
  end

  def card_classes
    "bg-gray-800 rounded-2xl p-6 border border-gray-700 shadow-lg"
  end

  def button_classes(variant: :primary)
    base_classes = "px-4 py-2 rounded-lg transition-colors transform hover:scale-105"

    case variant
    when :primary
      "#{base_classes} bg-green-600 hover:bg-green-500 text-white"
    when :secondary
      "#{base_classes} bg-gray-700 hover:bg-gray-600 text-white"
    when :danger
      "#{base_classes} bg-red-600 hover:bg-red-500 text-white"
    else
      "#{base_classes} bg-blue-600 hover:bg-blue-500 text-white"
    end
  end

  def filter_button_classes(active: false)
    base_classes = "px-3 py-1 rounded text-sm transition-colors"
    active ? "#{base_classes} bg-green-500 text-white" : "#{base_classes} bg-gray-700 text-gray-300 hover:bg-gray-600"
  end
end
