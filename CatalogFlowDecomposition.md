Миланович Эмилия Романовна
<br /> Когорта: 10
<br />  Группа: 2
<br /> Эпик: Каталог
<br /> Ссылка: https://github.com/users/TatyanaVildanova/projects/2/views/1?pane=issue&itemId=52963998

# Catalog Flow Decomposition


## Module 1:

#### Экран каталога

##### Верстка
- NavBar (est: 10 min; fact: 60 min).
- Таблица (est: 60 min; fact: 30 min).
- Ячейка таблицы (est: 60 min; fact: 60 min).


##### Логика
- Сортировка коллекций (est: 90 min; fact: 60 min).
- Переход на экран коллекции (est: 10 min; fact: 10 min).

`Total:` est: 230 min; fact: 220 min.


## Module 2:

#### Экран NFT коллекции

##### Верстка
- NavBar (est: 10 min; fact: 30 min).
- Превью NFT коллекции (est: 30 min; fact: 10 min).
- Описание NFT коллекции (est: 30 min; fact: 30 min).
- Коллекция (est: 60 min; fact: 60 min).
- Ячейка коллекции (est: 120 min; fact: 120 min).


`Total:` est: 250 min; fact: 250 min.


## Module 3:

#### Экран NFT коллекции

##### Логика
- Добавление в корзину (est: 60 min; fact: x min).
- Добавление в избранное (est: 90 min; fact: x min).
- Переход на экран автора (est: 10 min; fact: x min).


#### Экран автора

##### Верстка
- NavBar (est: 10 min; fact: x min).
- WebView (est: 60 min; fact: x min).


`Total:` est: 230 min; fact: x min.


