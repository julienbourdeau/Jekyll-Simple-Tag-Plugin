##
# The MIT License (MIT)
# 
# Copyright (c) 2014 Julien Bourdeau
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
#
# Example:
#  opening: {% alert success %}
#  closing: {% endalert %}

module Jekyll
  class AlertsTag < Liquid::Tag

    def render(context)
      if tag_contents = determine_arguments(@markup.strip)
        alert_type, dismissible = tag_contents[0], tag_contents[1]
        alert_tag(alert_type, dismissible)
      else
        raise ArgumentError.new <<-eos
Syntax error in tag 'alert' while parsing the following markup:

  #{@markup}

Valid syntax:
  opening: {% alert success %}
  closing: {% endalert %}
eos
      end
    end

    private

    def determine_arguments(input)
      matched = input.match(/\A(\S+) ?(\S+)?\Z/)
      [matched[1].to_s.strip, matched[2].to_s.strip] if matched && matched.length >= 3
    end

    def alert_tag(alert_type, dismissible = nil)
      if dismissible.empty?
        "<div class='alert alert-#{alert_type}' role='alert'>"
      else
        "<div class='alert alert-#{alert_type} alert-dismissible' role='alert'>\
        <button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
      end
    end
  end
end

module Jekyll
  class EndAlertsTag < Liquid::Tag

    def render(context)
      "</div>"
    end

  end
end

Liquid::Template.register_tag('alert', Jekyll::AlertsTag)
Liquid::Template.register_tag('endalert', Jekyll::EndAlertsTag)
