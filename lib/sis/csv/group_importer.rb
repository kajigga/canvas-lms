#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require 'lib/sis/csv/base_importer'

module SIS
  module CSV
    # note these are account-level groups, not course groups
    class GroupImporter < BaseImporter
      def self.is_group_csv?(row)
        row.header?('group_id') && row.header?('account_id')
      end

      # expected columns
      # group_id,account_id,name,status
      def process(csv)
        @sis.counts[:groups] += SIS::GroupImporter.new(@root_account, importer_opts).process do |importer|
          csv_rows(csv) do |row|
            update_progress

            begin
              importer.add_group(row['group_id'], row['account_id'], row['name'], row['status'])
            rescue ImportError => e
              add_warning(csv, "#{e}")
            end
          end
        end
      end
    end
  end
end
