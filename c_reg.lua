-- КЛИЕНТ
-- АВТОР: RastaOrecha
    Logininput = guiCreateEdit(660, 443, 256, 23, getPlayerName(localPlayer), false) -- Создадим поле ввода логина и вобъём в него ник игрока
	guiEditSetMaxLength(Logininput, 24) -- Устанавливаем макс.дину ника в 24
	Passwordinput = guiCreateEdit(660, 500, 256, 23, "", false) -- Создаём поле ввода пароля
    guiEditSetMaxLength(Passwordinput, 16) -- Устанавливаем макс.дину пароля в 16
	--
	Registerbutton = guiCreateButton(649, 583, 277, 32, "", false) -- Создаём кнопку
    guiSetAlpha(Registerbutton, 0.00)
	Informationbutton = guiCreateButton(425, 581, 202, 34, "", false)
    guiSetAlpha(Informationbutton, 0.00)
	reg_draw_image = 1

	showCursor ( true ) -- Показываем курсор
	toggleAllControls ( false )  -- Отключаем игроку управление
	setCameraMatrix (1678.2035,-1481.4669,110.1527, 1614.6501,-1576.7792,88.1527) -- Куда смотрит камера X,Y,Z, [LX, LY, LZ]
	
	function buttonClick() 
		if source == Registerbutton then  -- Если игрок кликнул по кнопке "Далее"
			triggerServerEvent("registerCheck",localPlayer,guiGetText(Logininput),md5(guiGetText(Passwordinput))) -- Посылаем триггер на сервер, ибо на клиенте нет MySQL функций
		end
	end
	addEventHandler("onClientGUIClick",root,buttonClick) -- Срабатывает при клике по GUI компонентам
	
	addEvent("hideGUI",true)
	function regPorccess() 
			destroyElement(Logininput) 
			destroyElement(Passwordinput) 
			destroyElement(Informationbutton) 
			destroyElement(Registerbutton) 
			destroyElement(myTexture)
			setElementData ( localPlayer, "Logged", 1 )
			reg_draw_image = 0
			showCursor ( false )  -- Скрываем курсор
			toggleAllControls ( true )  -- Включаем игроку управление
			setCameraTarget ( localPlayer ) -- Наводим камеру на игрока
			fadeCamera ( true ) -- Включаем камеру
			setElementModel(localPlayer, 19) -- Установим 19 скин
			
	end
	addEventHandler("hideGUI", root, regPorccess) 
	
	addEvent( "onClientGotImage", true )
	addEventHandler( "onClientGotImage", resourceRoot,
		function( pixels )
			--[[if myTexture then
				destroyElement( myTexture )
			end]]
			myTexture = dxCreateTexture( pixels )
		end)
	 
	addEventHandler("onClientRender", root,
		function()
			if myTexture and reg_draw_image == 1 then
				dxDrawImage( 427, 367, 500, 250, myTexture )
			end 
		end)