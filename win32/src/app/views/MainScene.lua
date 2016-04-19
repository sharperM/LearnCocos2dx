require "app.logic.log"
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
function MainScene:onCreate()
	log("MainScene:onCreate()")
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

     -- self:addChild(self:createMonsterLayer())
     self:LoadImg()



    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
            print("select child index = ",sender:getCurSelectedIndex())
        end
    end

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
            print("SCROLL_TO_BOTTOM")
        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
            print("SCROLL_TO_TOP")
        end
    end
    local backgroundSize = self:getContentSize()
    local widgetSize = {["width"] = 100,["height"] = 100}
    local listView = ccui.ListView:create()
    -- set list view ex direction
    listView:setDirection(ccui.ScrollViewDir.vertical)
    -- listView:setBounceEnabled(true)
    -- listView:setBackGroundImage("cocosui/green_edit.png")
    -- listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(400, 600))
    listView:setPosition(cc.p((widgetSize.width - backgroundSize.width) / 2.0 +
                                 (backgroundSize.width - listView:getContentSize().width) / 2.0,
                             (widgetSize.height - backgroundSize.height) / 2.0 +
                                 (backgroundSize.height - listView:getContentSize().height) / 2.0))
    listView:addEventListener(listViewEvent)
    listView:addScrollViewEventListener(scrollViewEvent)
    listView:setAnchorPoint(cc.p(0,0))
    listView:setPosition(cc.p(0,0))
    self:addChild(listView)



	for i=1,10 do
		log(i,i+100)
		local item = ccui.Layout:create()
		item:setContentSize(400,100)
        item:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
        item:setBackGroundColor(cc.c3b(math.random(0,255), math.random(0,255), math.random(0,255)))
		listView:addChild(item)
	    local ClipNode = cc.ClippingNode:create()
	    local maskNode = cc.Node:create()
	    maskNode:addChild(cc.Sprite:create("mask.png"))
	    ClipNode:setAlphaThreshold(0)
	    ClipNode:setStencil(maskNode)
	    ClipNode:addChild(cc.Sprite:createWithTexture(display.getImage("3DS - Pokemon Battle Trozei - Small Pokemon Icons.png"),
	    	cc.rect(math.random(1,500),math.random(1,500),100,100)))
	    ClipNode:setPosition(cc.p(50,50))

	    -- local target = cc.RenderTexture:create(100, 100, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
		-- target:begin()
		-- ClipNode:visit()
		-- target:endToLua()
		-- target:setPosition(50,50)
		-- item:addChild(target)

		item:addChild(ClipNode)
	end

end
function MainScene:LoadImg( ... )
	display.loadImage("3DS - Pokemon Battle Trozei - Small Pokemon Icons.png")
end
function MainScene:createMonsterLayer( ... )
	-- add HelloWorld label
	local self = cc.Layer:create()
    local text = cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)


	local allMonster = {}
	for i=1,9 do
		local r = math.random(0,24*31+15)
		local x,y = math.fmod(r,24),math.floor(r/24)
		local s = CCSprite:createWithTexture(display.getImage("3DS - Pokemon Battle Trozei - Small Pokemon Icons.png"),
			cc.rect(x*64,y*64,64,64)):setAnchorPoint(cc.p(0.5,0)):move(display.cx+math.fmod(i-1,3)*64,display.cy+math.floor((i-1)/3)*64):addTo(self)
		local a1 = cc.EaseBackIn:create(cc.ScaleBy:create(0.5,1.1,0.9))
		local function callback( ... )
			local r = math.random(0,24*31+15)
			local x,y = math.fmod(r,24),math.floor(r/24)
			s:setTextureRect(cc.rect(x*64,y*64,64,64))
		end
		allMonster[i] = s
		s:runAction(cc.RepeatForever:create(cc.Sequence:create(a1,a1:reverse()--[[,CCCallFunc:create(callback)]])))
	end

	local touchLayer = CCLayer:create():addTo(self)
	local rects = {}
	local moveMonsterIndex
	local beginPoint
	local monsterBeginPoint
	for i=1,9 do
		local x,y = math.fmod(i-1,3),math.floor((i-1)/3)
		rects[i]=cc.rect(display.cx-32+x*64, display.cy+y*64,64,64)
	end

	local function swapMonster( pt1,pt2 )

	end

    local function onTouchEnded(touch, event)
  		local location = touch:getLocation();
  		local ret = false
  		for i=1,9 do
  			if cc.rectContainsPoint (rects[i],location) then
  				print (i)
  				local x,y = allMonster[i]:getPosition()
				allMonster[i]:setPosition(monsterBeginPoint.x,monsterBeginPoint.y)
				allMonster[moveMonsterIndex]:setPosition(x,y)
				local temp = allMonster[i]
				allMonster[i] = allMonster[moveMonsterIndex]
				allMonster[moveMonsterIndex] = temp
				moveMonsterIndex = nil
				monsterBeginPoint = nil
				beginPoint = nil
				ret = true
  				break;
  			end
  		end
  		if ret == false then
  			allMonster[moveMonsterIndex]:setPosition(monsterBeginPoint.x,monsterBeginPoint.y)
  		end
    end
    local function onTouchBegan(touch, event)
  		local location = touch:getLocation();
  		for i=1,9 do
  			if cc.rectContainsPoint (rects[i],location) then
  				print (i)
  				moveMonsterIndex = i
  				beginPoint = location
  				monsterBeginPoint = cc.p(allMonster[moveMonsterIndex]:getPosition())
  				break;
  			end
  		end
  		return true
    end
    local function onTouchMoved( touch, event )
  		local location = touch:getLocation();
  		text:setString(string.format("%d,%d",location.x,location.y))
  		local pos = cc.pAdd(monsterBeginPoint,cc.pSub(location,beginPoint))
  		allMonster[moveMonsterIndex]:move(pos.x,pos.y)
    end 
	local touchListener = cc.EventListenerTouchOneByOne:create();
	touchListener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN);
	touchListener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED);
	touchListener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED);
	local eventDispatcher = touchLayer:getEventDispatcher();
	eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, touchLayer);
	return self
end

return MainScene;


-- local MonsterGrid = class("MonsterGrid", cc.load("mvc").ViewBase)

-- function MonsterGrid:SwapMonster(d,s)
	
-- end
-- function MonsterGrid:init(Present)
-- 	self.allMonster = {}
-- 	for i=1,9 do
-- 		local r = math.random(0,24*31+15)
-- 		local x,y = math.fmod(r,24),math.floor(r/24)
-- 		local s = CCSprite:createWithTexture(display.getImage("3DS - Pokemon Battle Trozei - Small Pokemon Icons.png"),
-- 			cc.rect(x*64,y*64,64,64)):setAnchorPoint(cc.p(0.5,0)):move(display.cx+math.fmod(i-1,3)*64,display.cy+math.floor((i-1)/3)*64):addTo(self)
-- 		local a1 = cc.EaseBackIn:create(cc.ScaleBy:create(0.5,1.1,0.9))
-- 		local function callback()
-- 			local r = math.random(0,24*31+15)
-- 			local x,y = math.fmod(r,24),math.floor(r/24)
-- 			s:setTextureRect(cc.rect(x*64,y*64,64,64))
-- 		end
-- 		allMonster[i] = s
-- 		s:runAction(cc.RepeatForever:create(cc.Sequence:create(a1,a1:reverse()--[[,CCCallFunc:create(callback)]])))
-- 	end
-- end
