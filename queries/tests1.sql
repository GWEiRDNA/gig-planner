drop table if exists osoby cascade;
create table osoby
    (
        id bigserial not null primary key,
        imi� varchar(20) not null,
        nazwisko varchar(50) not null,
        data_urodzenia date not null
    );

    insert into osoby values (default, 'Zenek', 'Martyniuk', '30/4/1945');
    insert into osoby values (default, 'Jan', 'Kaczy�ski', '20/4/1889');

        
