module DashboardHelper
  def progress_color(percentage)
    if percentage >= 80
      "bg-green-500"
    elsif percentage >= 50
      "bg-yellow-500"
    else
      "bg-blue-500"
    end
  end

  def priority_color(priority)
    case priority
    when "low" then "text-gray-400"
    when "medium" then "text-blue-400"
    when "high" then "text-orange-400"
    when "urgent" then "text-red-400"
    else "text-gray-400"
    end
  end
end
