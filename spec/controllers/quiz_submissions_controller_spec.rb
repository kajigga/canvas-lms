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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe QuizSubmissionsController do

  describe "POST 'create'" do
    it "should allow previewing" do
      course_with_teacher_logged_in(:active_all => true)
      @quiz = @course.quizzes.create!
      @quiz.workflow_state = "available"
      @quiz.quiz_data = [{:correct_comments=>"", :assessment_question_id=>nil, :incorrect_comments=>"", :question_name=>"Question 1", :points_possible=>1, :question_text=>"Which book(s) are required for this course?", :name=>"Question 1", :id=>128, :answers=>[{:weight=>0, :text=>"A", :comments=>"", :id=>1490}, {:weight=>0, :text=>"B", :comments=>"", :id=>1020}, {:weight=>0, :text=>"C", :comments=>"", :id=>7051}], :question_type=>"multiple_choice_question"}]
      @quiz.save!

      post 'create', :course_id => @quiz.context_id, :quiz_id => @quiz.id, :preview => 1
      response.should be_redirect
    end
  end
  
  describe "PUT 'update'" do
    it "should require authentication" do
    course_with_teacher(:active_all => true)
      quiz_with_submission
      put 'update', :course_id => @quiz.context_id, :quiz_id => @quiz.id, :id => @qsub.id
      assert_unauthorized
    end
    
    it "should allow updating scores if the teacher is logged in" do
      course_with_teacher(:active_all => true)
      quiz_with_submission
      user_session(@teacher)
      put 'update', :course_id => @quiz.context_id, :quiz_id => @quiz.id, :id => @qsub.id, "question_score_128" => "2"
      response.should be_redirect
      assigns[:submission].should_not be_nil
      assigns[:submission].submission_data[0][:points].should == 2
    end
    
    it "should not allow updating if the course is concluded" do
      course_with_teacher(:active_all => true)
      quiz_with_submission
      @enrollment.conclude
      put 'update', :course_id => @quiz.context_id, :quiz_id => @quiz.id, :id => @qsub.id
      assert_unauthorized
    end
  end
end
  

  
