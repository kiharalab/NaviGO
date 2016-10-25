SELECT acc, @row := @row + 1 as row FROM `GO_CATEGORY`, (SELECT @row := -1) r where category = "f" order by "acc";
