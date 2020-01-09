# frozen_string_literal: true

# :Application Helper:
module ApplicationHelper
  def active?(c_name, m_name)
    controller_name == c_name && action_name == m_name ? 'active' : ''
  end
end
