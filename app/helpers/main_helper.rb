module MainHelper
	def inline_form
		form_tag("/", method:"post", class:"form-inline inline") do
			hidden = hidden_field_tag 'query', '\1', class:"inline"
			link = link_to '\1', "#", :onclick => "$(this).closest('form').submit()", class:"inline"
			hidden + link
		end
	end

	def format_courselist(txt)
		raw txt.gsub(/([A-Za-z]*\s*\d+[A-Za-z]*)/, inline_form.strip) #strip off some whitespace that seems to come w the form
	end

	def format_instructors(txt)
		raw txt.split("; ").map {|i| "<a>#{i}</a>"}.join("; ")
	end

	def enroll_bar_style(course)
		return "success" if course.enroll_percent < 75 || course.no_cap?
		return "warning" if course.enroll_percent < 90
		return "danger"
	end

	def enroll_bar_precentage(course)
		return 100 if course.no_cap?
		course.enroll_percent
	end

	def format_time(time)
		if time.size == 3 #940
			hour = time[0].to_i #9
			mins = time[1..2] #40
		else #1050
			hour = time[0..1].to_i #10
			mins = time[2..3] #50
		end
		am = hour < 12
		if hour > 12
			hour = "#{hour - 12}"
		end
		"#{hour}:#{mins}#{am ? "am" : "pm"}"
	end

	def formatted_time_and_day(course)
		days_of_week = {"M" => "Mon", "T" => "Tues", "W" => "Wed", "R" => "Thurs", "F" => "Fri"}
		# days is like "MWF". split into chars, map each one to the longer version, join with /, so Mon/Wed/Fri
		d = course.days.split("").map {|d| days_of_week[d]}.join("/")
		s = format_time(course.start_time.to_s)
		e = format_time(course.end_time.to_s)
		"#{d} #{s}-#{e}"
	end
end
