-- СЕРВЕР
-- АВТОР: RastaOrecha
hconnect = dbConnect( "mysql", "dbname=rastas;host=127.0.0.1", "root", "", "share=1" ) -- Подключаемся к БД "rastas"

addEvent("registerCheck",true)
function playerRegister(username,password)
	local ch = dbQuery(hconnect, "SELECT `Name` FROM `users` WHERE `Name`=?", username) -- Отправляем запрос и отсеиваем поля с именем "username"
	local results = dbPoll(ch, -1 ) -- Захватываем результат сканирования
	if #results == 0 then -- Если в течение запроса не найдено полей, то регистрируем
		-- РЕГИСТРАЦИЯ
		setPlayerName ( source, username)
		outputChatBox("[•] Вы успешно зарегистрировались", source)
		local insert = dbQuery( hconnect, "INSERT INTO `users` (`Name`,`Key`) VALUES (?,?)", username, password ) -- Создадим поле с аккакнтом игрока
		dbFree( insert )
		spawnPlayer(source, 2511.8999, -1689, 13.6999 )
		triggerClientEvent("hideGUI", source) -- Убираем GUI 
	else -- Если нашло поле с именем "username"
		local lg = dbQuery(hconnect, "SELECT `Name`,`Key` FROM `users` WHERE `Name`=? and `Key` =?", username, password) -- Отправляем запрос и отсеиваем поле с именем "username" и паролем "password"
		local rslt = dbPoll( lg, -1 ) -- Захватываем результат сканирования
		if #rslt == 0 then -- Если таких ячеек не нашлось, то пароль введён неверно
			outputChatBox("[•] Неверный пароль", source) -- Выведем сообщение на экран
		else -- Если всё верно, то авторизуем
			-- ЛОГИН
			
			local ld = dbQuery ( hconnect, "SELECT `Stats` FROM `users` WHERE `Name`=?", username )
			local result = dbPoll ( ld, -1 )
			local stats = fromJSON ( result [ 1 ].Stats )
			if ( type ( stats ) == "table" ) then
				spawnPlayer(source, stats.posX, stats.posY, stats.posY) -- Заспавним игрока по указанным координатам
				setElementRotation(source, stats.posRX, stats.posRY, stats.posRZ)
				setElementInterior(source, stats.int)
				setElementDimension(source, stats.world)
				setElementHealth(source, stats.health)
				setPedArmor(source, stats.armour)
			end
			setPlayerName ( source, username) -- Установим игроку ник на введённый в окошке регистрации
			outputChatBox("[•] Вы успешно авторизовались", source)  -- Выведем сообщение о авторизации
			triggerClientEvent("hideGUI", source) -- Убираем GUI 
		end
	end
end
addEventHandler("registerCheck",root,playerRegister)

function OnPlayerDisconnect ( quitType, reason )
	if getElementData ( source, "Logged") == 1 then -- Если игрок авторизован
		local stats = {}
		stats.posX,stats.posY,stats.posZ = getElementPosition (source)
		stats.posRX,stats.posRY,stats.posRZ = getElementRotation (source)
		stats.int = getElementInterior (source)
		stats.world = getElementDimension (source)
		stats.health = getElementHealth (source)
		stats.armour = getPedArmor (source)		
		local save = dbQuery( hconnect, "UPDATE `users` SET `Stats`=? WHERE `Name`=?",  toJSON ( stats ), getPlayerName ( source ) ) -- Сохраним статистику игрока
		dbFree( save )
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), OnPlayerDisconnect )

function OnPlayerConnect ( )
	fetchRemote ( "http://savepic.net/3835213.jpg", myCallback, "", false, source )
end
addEventHandler ( "onPlayerJoin", getRootElement(), OnPlayerConnect )

function myCallback( responseData, errno, playerToReceive )
    if errno == 0 then 
		triggerClientEvent( playerToReceive, "onClientGotImage", resourceRoot, responseData ) 
	end
end


-- { "posRX": 0, "posY": -2258.998047, "posRZ": 17.597626, "armour": 0, "int": 0, "posX": 1502.027344, "health": 100.392166, "posZ": 13.546875, "posRY": 0, "world": 0 } 