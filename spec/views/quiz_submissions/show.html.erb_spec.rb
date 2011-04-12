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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../views_helper')

describe "/quiz_submissions/show" do
  it "should render" do
    course_with_student
    view_context
    @submission = mock_model(QuizSubmission)
    @submission.stub!(:score).and_return(10)
    @submission.stub!(:data).and_return([])
    @quiz = mock_model(Quiz)
    @quiz.stub!(:questions).and_return([])
    @quiz.stub!(:points_possible).and_return(10)
    @quiz.stub!(:stored_questions).and_return([])
    assigns[:quiz] = @quiz
    assigns[:submission] = @submission
    
    render "quiz_submissions/show"
    response.should_not be_nil
  end
end
