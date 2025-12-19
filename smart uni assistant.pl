% =====================================================
% Smart University Assistant System
% Prolog Final Project
% =====================================================

:- dynamic student/4.
:- dynamic enrolled/2.

% -----------------------------------------------------
% Knowledge Base
% -----------------------------------------------------

% course(CourseName, Department, Level).
course(intro_programming, cs, level1).
course(calculus_i, general, level1).
course(logic_programming, cs, level2).
course(database_systems, cs, level2).
course(discrete_math, general, level2).
course(software_engineering, cs, level3).
course(artificial_intelligence, cs, level3).
course(networking, cs, level3).

% classroom(Course, Room).
classroom(intro_programming, 'B-101').
classroom(logic_programming, 'C-202').
classroom(calculus_i, 'A-305').
classroom(artificial_intelligence, 'C-202').
classroom(database_systems, 'B-101').
classroom(software_engineering, 'A-305').
classroom(networking, 'D-404').
classroom(discrete_math, 'A-101').

% schedule(Day, Course, Time).
schedule(monday, intro_programming, '9:00 AM').
schedule(monday, discrete_math, '11:00 AM').
schedule(tuesday, logic_programming, '1:00 PM').
schedule(wednesday, artificial_intelligence, '10:00 AM').
schedule(thursday, database_systems, '9:00 AM').
schedule(thursday, networking, '1:00 PM').

% study tips
tip(exam, 'Solve past exams and revise important topics.').
tip(focus, 'Study in short sessions and avoid distractions.').
tip(general, 'Organize your time and take breaks regularly.').

% -----------------------------------------------------
% Rules
% -----------------------------------------------------

recommend_course(Level, Dept, Course) :-
    course(Course, Dept, Level).

find_classroom(Course, Room) :-
    classroom(Course, Room).

course_schedule(Course, Day, Time, Room) :-
    schedule(Day, Course, Time),
    classroom(Course, Room).

conflict(C1, C2, Day, Time) :-
    schedule(Day, C1, Time),
    schedule(Day, C2, Time),
    C1 \= C2.

% -----------------------------------------------------
% System Start
% -----------------------------------------------------

start :-
    write('===================================='), nl,
    write(' Smart University Assistant System'), nl,
    write('===================================='), nl,
    register_student,
    main_menu.

% -----------------------------------------------------
% Student Registration
% -----------------------------------------------------

register_student :-
    write('Enter your name: '), read(Name),
    write('Enter your department (cs. / general.): '), read(Dept),
    write('Enter your level (level1. / level2. / level3.): '), read(Level),
    write('Enter your GPA: '), read(GPA),
    assertz(student(Name, Dept, Level, GPA)),
    write('Student registered successfully.'), nl.

% -----------------------------------------------------
% Main Menu
% -----------------------------------------------------

main_menu :-
    nl,
    write('1. Find classroom'), nl,
    write('2. Recommend courses'), nl,
    write('3. View daily schedule'), nl,
    write('4. View course schedule'), nl,
    write('5. Enroll in course'), nl,
    write('6. Check conflict'), nl,
    write('7. Get study tip'), nl,
    write('8. Student report'), nl,
    write('9. Exit'), nl,
    read(Choice),
    handle_choice(Choice).

% -----------------------------------------------------
% Menu Choices
% -----------------------------------------------------

handle_choice(1) :-
    write('Enter course: '), read(Course),
    find_classroom(Course, Room),
    format('Classroom: ~w~n', [Room]),
    main_menu.

handle_choice(2) :-
    student(_, Dept, Level, _),
    write('Recommended courses:'), nl,
    (
        recommend_course(Level, Dept, Course),
        format('- ~w~n', [Course]),
        fail
    ;
        true
    ),
    main_menu.

handle_choice(3) :-
    write('Enter day: '), read(Day),
    (
        schedule(Day, Course, Time),
        format('- ~w at ~w~n', [Course, Time]),
        fail
    ;
        true
    ),
    main_menu.

handle_choice(4) :-
    write('Enter course: '), read(Course),
    (
        course_schedule(Course, Day, Time, Room),
        format('~w - ~w - ~w~n', [Day, Time, Room]),
        fail
    ;
        true
    ),
    main_menu.

handle_choice(5) :-
    write('Enter your name: '), read(Name),
    write('Enter course: '), read(Course),
    (
        \+ (enrolled(Name, C), conflict(C, Course, _, _)),
        assertz(enrolled(Name, Course)),
        write('Course enrolled successfully.'), nl
    ;
        write('Cannot enroll due to conflict.'), nl
    ),
    main_menu.

handle_choice(6) :-
    write('Enter first course: '), read(C1),
    write('Enter second course: '), read(C2),
    (
        conflict(C1, C2, Day, Time),
        format('Conflict on ~w at ~w~n', [Day, Time])
    ;
        write('No conflict found.'), nl
    ),
    main_menu.

handle_choice(7) :-
    write('Enter tip type (exam. / focus. / general.): '),
    read(Type),
    tip(Type, Tip),
    format('Tip: ~w~n', [Tip]),
    main_menu.

handle_choice(8) :-
    write('Enter student name: '), read(Name),
    student(Name, Dept, Level, GPA),
    write('--- Student Report ---'), nl,
    format('Department: ~w~n', [Dept]),
    format('Level: ~w~n', [Level]),
    format('GPA: ~w~n', [GPA]),
    write('Enrolled Courses:'), nl,
    (
        enrolled(Name, Course),
        format('- ~w~n', [Course]),
        fail
    ;
        true
    ),
    main_menu.

handle_choice(9) :-
    write('Goodbye.'), nl.

