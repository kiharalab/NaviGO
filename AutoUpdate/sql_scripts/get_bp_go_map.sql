SELECT acc, @row := @row + 1 as row FROM `GO_CATEGORY`, (SELECT @row := -1) r where category = "p" order by "acc";
