INSERT INTO `servermail`.`virtual_domains`
  (`id` ,`name`)
  VALUES
    ('1', 'example.com'),
    ('2', 'hostname.example.com');

INSERT INTO `servermail`.`virtual_users`
  (`id`, `domain_id`, `password` , `email`)
  VALUES
    ('1', '1', ENCRYPT('firstpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email1@example.com'),
    ('2', '1', ENCRYPT('secondpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email2@example.com');

INSERT INTO `servermail`.`virtual_aliases`
  (`id`, `domain_id`, `source`, `destination`)
  VALUES
    ('1', '1', 'alias@example.com', 'email1@example.com');

