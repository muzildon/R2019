# Загрузка пакетов
library('XML')                 # разбор XML-файлов
library('RCurl')               # работа с HTML-страницами
library('rjson')               # чтение формата JSON
library('rvest') # работа с DOM сайта
library('dplyr')     # инструменты трансформирования данных

#Соберем данные по 100 лучшим фильмам за 2018 год по версии Кинопоиска

#загружаем URL

url<-'https://www.kinopoisk.ru/top/navigator/m_act[year]/2018/m_act[num_vote]/100/m_act[rating]/1%3A/m_act[gross]/%3A800/m_act[gross_type]/domestic/order/budget/perpage/100/#results'

# читаем HTML страницы
webpage <- read_html(url)

# 1 отбор названий фильмов по селектору
title_data <- html_nodes(webpage,'div.name a') %>% html_text
head(title_data)
str(title_data)

#2 бюджет фильма
cost <- html_nodes(webpage, '.gray3') %>% html_text()
head(cost)
cost <- gsub('\\s', '',cost)
cost <- gsub('[$]','', cost)
head(cost)
str(cost)

#3 режиссер
producer <- html_nodes(webpage, 'span i') %>% html_text()
producer <- gsub('реж. ', '',producer)
head(producer)
str(producer)

#4 продолжительность фильмов
time <- html_nodes(webpage, 'nobr') %>% html_text()
head(time)
time <- as.numeric(gsub('\\sмин.', '',time))
head(time)
str(time)

#5 информация по фильмам
information <- html_nodes(webpage, 'div.name span') %>% html_text
head(information)

#6 оценки фильма с сайта кинопоиск
mark <- html_nodes(webpage, '.numVote') %>% html_text()
mark<- gsub('\\s\\(.*\\)', '',mark)
mark<- as.numeric(mark)
head(mark)
str(mark)

#7 количество поставивших оценку
count_mark <- gsub('\\d.\\d*\\s\\(', '',mark)
count_mark <- gsub('\\)','',count_mark)
count_mark <- gsub('\\s','', count_mark)
count_mark <- as.numeric(count_mark)
head(count_mark)
str(count_mark)

#8 оценка с сайта IMDb
imdb <- html_nodes(webpage,'div.imdb') %>% html_text
head(imdb)
imdb <- gsub('IMDb: ','',imdb)
imdb <- gsub('\\s\\d*','',imdb)
imdb <- as.numeric(imdb) #final version for this
head(imdb)
str(imdb)

DF.movies <- data.frame('Title'=title_data,
                        'Cost'= cost,
                        'Producer'= producer,
                        'Time'=time,
                        'year' = 2018,
                        'Marks from kinopoisk'= mark,
                        'Count for mark' = count_mark,
                        'IMDb mark'=imdb)
dim(DF.movies)
str(DF.movies)

#записать файл csv
write.csv(DF.movies, file = '../data_movies_2018.csv', row.names = F)

getwd() 
