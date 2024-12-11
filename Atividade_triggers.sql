--1 - Quando adicionar um defunto deve ser disparado uma trigger que já aloque o defunto em um jazigo;
DELIMITER $$
CREATE TRIGGER `after_insert_defunto` 
AFTER INSERT ON `DEFUNTO`
FOR EACH ROW
BEGIN

    DECLARE idJazigoDisponivel INT;
    SELECT `idJazigo` INTO idJazigoDisponivel
    FROM `JAZIGO`
    WHERE `idDefuntoJazigo` = 0
    LIMIT 1;

    IF idJazigoDisponivel IS NOT NULL THEN
        UPDATE `JAZIGO`
        SET `idDefuntoJazigo` = NEW.idDefunto
        WHERE `idJazigo` = idJazigoDisponivel;
    END IF;
END$$
DELIMITER ;

--2 - Quando deletar um defunto deve ser disparado uma triggers para liberar o jazigo oculpado pelo defunto;
DELIMITER $$
CREATE TRIGGER `after_delete_defunto` 
AFTER DELETE ON `DEFUNTO`
FOR EACH ROW
BEGIN
    DECLARE idJazigoOcupado INT;
    SELECT `idJazigo` INTO idJazigoOcupado
    FROM `JAZIGO`
    WHERE `idDefuntoJazigo` = OLD.idDefunto;

    IF idJazigoOcupado IS NOT NULL THEN
        DELETE FROM `JAZIGO`
        WHERE `idJazigo` = idJazigoOcupado;
    END IF;
END$$
DELIMITER ;
