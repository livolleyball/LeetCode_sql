
* 新建多选选项表types 以及 选择结果表 user_MultiSelect
``` sql
DROP TABLE IF EXISTS `types`;

CREATE TABLE `types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `types` smallint(6) NOT NULL,
  `comment` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

/*Data for the table `types` */

insert  into `types`(`id`,`types`,`comment`) values 

(1,1,'a'),

(2,2,'b'),

(3,3,'c'),

(4,4,'d'),

(5,5,'e'),

(6,6,'f'),

(7,7,'g'),

(8,8,'h'),

(9,9,'i'),

(10,10,'j');

/*Table structure for table `user_MultiSelect` */

DROP TABLE IF EXISTS `user_MultiSelect`;

CREATE TABLE `user_MultiSelect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `multiSelect` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Data for the table `user_MultiSelect` */

insert  into `user_MultiSelect`(`id`,`userId`,`multiSelect`) values 

(1,1,'1,2,3,'),

(2,2,'2,'),

(3,3,'5,6,7,'),

(4,7,'4,5'),

(5,9,'8,9,'),

(6,11,'10');
```

* 一个多选结果分拆成多行单选comment

```sql
SELECT b.id,a.`types`,a.comment,b.multiSelect
FROM `types`  a LEFT JOIN `user_MultiSelect` b ON LOCATE(a.types,b.multiSelect)>0  
一个多选结果对应其相应的多选comment

SELECT b.id,GROUP_CONCAT(a.comment),b.multiSelect
FROM `types`  a LEFT JOIN `user_MultiSelect` b ON LOCATE(a.types,b.multiSelect)>0  
GROUP BY b.id;
问题反思：当选项个数超过10 ， LOCATE(a.types,b.multiSelect)>0会将1,10+ 同时查询到，使用的时候 请添加相应的限制条件

SELECT b.id,a.`types`,a.comment,b.multiSelect
FROM `types`  a LEFT JOIN `user_MultiSelect` b ON find_in_set(a.types,b.multiSelect)>0 

```

