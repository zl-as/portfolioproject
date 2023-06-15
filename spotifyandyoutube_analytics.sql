/*---Write an SQL query to solve the given problem statement.---*/

/*1.	Which is the most viewed song track on youtube?*/
select track, views
from cleaned_dataset
order by views desc
limit 1;
 ---------------------------------------------------------------------------------------------------------------
 /*2.	Which Song track is streamed most on Spotify?*/
 
select track, stream
from cleaned_dataset
order by stream desc
limit 1;

-----------------------------------------------------------------------------------------------------------------------------
/*3.EnergyLiveness ratio is one of the popular ways to measure the quality of the song,
 which are the top 5 songs that have the highest energyliveness ratio.*/
 
Select Track, EnergyLiveness
from cleaned_dataset
order by EnergyLiveness desc
limit 5;

----------------------------------------------------------------------------------------------------------------------------
/*4. Let us assume a situation where an artist named Black Eyed Peas wants to analyze his songs. 
The artist wants to know which platform is capable of keeping his song track more engaged. 
To check this he assigns you this task and wants you to report to him where his song tracks are more played on. compare the platforms.*/


SELECT COUNT(Track) AS PlayCount, most_playedon AS Platform
FROM cleaned_dataset
WHERE Artist = 'Black Eyed Peas'
GROUP BY most_playedon
ORDER BY PlayCount DESC;

------------------------------------------------------------------------------------------------------------------
/*5. Gorillaz wants to know their most liked song on youtube.
 Report to them with their most liked song along with the Energy and Tempo of the song.*/
 
 Select Track,Likes, Energy,Tempo
 from cleaned_dataset
 where Artist = 'Gorillaz'
 order by likes desc
 limit 1;
 
 ------------------------------------------------------------------------------------------------------------------
 /*6.	Which Album types are more prominent on Spotify?*/
 
 select Album_Type, count(*) as Count_Album_Type
 from cleaned_dataset
 group by Album_Type
 order by Count_Album_Type desc;
 
 -------------------------------------------------------------------------------------------------------------------------------
 /* 7.	Spotify's most loved song tracks are to be declared soon. Help Spotify choose the top 5 most streamed+youtube viewed song track.*/
 
 select track, (Stream + Views) as Total_Views
 from cleaned_dataset
 group by track
 order by Total_Views desc 
 LIMIT 5;
 
 


 

 
 




