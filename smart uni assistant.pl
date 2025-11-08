% =================================================================
% Smart University Assistant
% =================================================================
% -----------------------------------------------------------------
% Knowledge Base
% -----------------------------------------------------------------

% Define Courses, Departments, and Levels: course(Course, Department, Level).
% Departments: cs (Computer Science), general (General Studies)
% Levels: level, leve2, leve3
course(intro_programming, cs, leve1).
course(calculus_i, general, leve1).
course(logic_programming, cs, leve2).
course(database_systems, cs, leve2).
course(discrete_math, general, leve2).
course(software_engineering, cs, leve3).
course(artificial_intelligence, cs, leve3).
course(networking, cs, leve3).

% Define Classroom for each course: classroom(Course, Room).
classroom(intro_programming, 'B-101').
classroom(logic_programming, 'C-202').
classroom(calculus_i, 'A-305').
classroom(artificial_intelligence, 'C-202').
classroom(database_systems, 'B-101').
classroom(software_engineering, 'A-305').

% Define Daily Schedule: schedule(Day, Course, Time).
% Day and Course must be entered as atoms (e.g., monday. or intro_programming.)
schedule(monday, intro_programming, '9:00 AM').
schedule(monday, discrete_math, '11:00 AM').
schedule(tuesday, logic_programming, '1:00 PM').
schedule(wednesday, artificial_intelligence, '10:00 AM').
schedule(thursday, database_systems, '9:00 AM').
schedule(thursday, networking, '1:00 PM').

% Define Study Tips: tip(Type, Advice).
% Types: exam, focus, general
tip(exam, 'Solve past year exams and review your critical notes.').
tip(focus, 'Keep your mobile phone away while studying and focus on one task.').
tip(general, 'Divide your time between studying and resting to avoid burnout.').


%  Logic Rules
% Rule to recommend a course based on level and department
recommend_course(Level, Dept, Course) :-
    course(Course, Dept, Level).
% Rule to find the classroom
find_classroom(Course, Room) :-
    classroom(Course, Room).
% Rule to get the schedule for a specific day
get_schedule(Day, Course, Time) :-
    schedule(Day, Course, Time).
% Rule to get a specific study tip
get_tip(Type, Tip) :-
    tip(Type, Tip).
% -----------------------------------------------------------------
%  User Interaction
% -----------------------------------------------------------------
start :-
    write('==========================================='), nl,
    write('Welcome to the Smart University Assistant '), nl,
    write('==========================================='), nl,
    main_menu.

% Display the main menu and read the user choice
main_menu :-
    nl,
    write('Please choose the required service:'), nl,
    write('1. Find Classroom Location.'), nl,
    write('2. Recommend a Course.'), nl,
    write('3. View Daily Schedule.'), nl,
    write('4. Get a Smart Study Tip.'), nl,
    write('5. Exit.'), nl,
    read(Choice),
    handle_choice(Choice).

% Handle the choices based on the menu number
handle_choice(1) :-
    write('--- Find Classroom Service ---'), nl,
    write('Enter the course name (as an atom, e.g.: logic_programming.): '),
    read(Course),
    (
        find_classroom(Course, Room) ->
        format('The classroom for ~w is: ~w.~n', [Course, Room])
        ;
        format('Sorry, no classroom found for course ~w.~n', [Course])
    ),
    main_menu.

handle_choice(2) :-
    write('--- Course Recommendation Service ---'), nl,
    write('Enter your department (cs. or general.): '), read(Dept),
    write('Enter your level (level1., level2., or level3.): '), read(Level),
    write('Recommended courses for you:'), nl,
    (
        % Use fail to display all results that satisfy the rule
        recommend_course(Level, Dept, Course),
        format('- ~w~n', [Course]),
        fail
    ;
        % Success after recommend_course fails brings the program back to the menu
        nl
    ),
    main_menu.

handle_choice(3) :-
    write('--- View Daily Schedule Service ---'), nl,
    write('Enter the day name (as an atom, e.g.: monday.): '), read(Day),
    write('Your schedule for '), write(Day), write(':'), nl,
    (
        % Use fail to display all courses on that day
        get_schedule(Day, Course, Time),
        format('- Course: ~w at Time: ~w~n', [Course, Time]),
        fail
    ;
        % Success after get_schedule fails
        format('No classes scheduled for ~w.', [Day]), nl
    ),
    main_menu.

handle_choice(4) :-
    write('--- Smart Study Tip Service ---'), nl,
    write('Choose tip type (exam., focus., or general.): '), read(Type),
    (
        get_tip(Type, Tip) ->
        format('Advice for you: ~w~n', [Tip])
        ;
        write('Sorry, that tip type is not available.'), nl
    ),
    main_menu.

handle_choice(5) :-
    write('Thank you for using the Smart University Assistant. Goodbye!'), nl.

handle_choice(_) :-
    write('Invalid choice. Please select from 1 to 5.'), nl,
    main_menu.
