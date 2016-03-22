module ("app.views.TouchLayer",package.seeall)


local TouchLayer = class("TouchLayer", cc.Layer)

-- function TouchLayer:onTouchBegan(touch,event)
-- 	print("onTouchBegan")
-- end
-- function TouchLayer:onTouchMoved(touch,event)
-- 	print("onTouchMoved")
-- end
-- function TouchLayer:onTouchEnded(touch,event)
-- 	print("onTouchEnded")
-- end
-- function TouchLayer:onTouchCancelled(touch,event)
-- 	print("onTouchCancelled")
-- end
-- function TouchLayer:onKeyPressed (keyCode,event)
-- 	print("onKeyPressed")
-- end
-- function TouchLayer:onKeyReleased (keyCode,event)
-- 	print("onKeyReleased")
-- end


local function create( ... )
	
	CCLayer:create()
end