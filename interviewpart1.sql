select * from student_response
select * from correct_answer

with cte as
(select sl.roll_number, sl.student_name,sl.class, sl.section,sl.school_name
, sum(case when sr.option_marked = ca.correct_option and qp.subject ='Math' and sr.option_marked <> 'e'
  	then 1 else 0 end) as math_correct
, sum(case when sr.option_marked <> ca.correct_option and qp.subject ='Math' and sr.option_marked <> 'e'
	 then 1 else 0 end) as math_wrong
,sum(case when qp.subject ='Math' and sr.option_marked = 'e'
	 then 1 else 0 end) as math_yet_to_learn
,sum(case when qp.subject ='Math' 
	 then 1 else 0 end) as math_total
 
, sum(case when sr.option_marked = ca.correct_option and qp.subject ='Science' and sr.option_marked <> 'e'
  	then 1 else 0 end) as Science_correct
, sum(case when sr.option_marked <> ca.correct_option and qp.subject ='Science' and sr.option_marked <> 'e'
	 then 1 else 0 end) as Science_wrong
,sum(case when qp.subject ='Science' and sr.option_marked = 'e'
	 then 1 else 0 end) as Science_yet_to_learn
,sum(case when qp.subject ='Science' 
	 then 1 else 0 end) as Science_total
from student_list sl
join student_response sr
	on sl.roll_number = sr.roll_number
join correct_answer ca
	on ca.question_paper_code = sr.question_paper_code and ca.question_number = sr.question_number
join question_paper_code qp
	on qp.paper_code = sr.question_paper_code
--where sl.roll_number = 10159
group by sl.roll_number, sl.student_name,sl.class, sl.section,sl.school_name)

select roll_number, student_name,class, section,school_name
,math_correct, math_wrong,math_yet_to_learn,math_correct as math_score, 
round((math_correct::decimal/math_total::decimal)*100,2) as math_percentage
,Science_correct, Science_wrong,Science_yet_to_learn,Science_correct as Science_score,
round((Science_correct::decimal/Science_total::decimal)*100,2) as Science_percentage
from cte
order by math_score desc



