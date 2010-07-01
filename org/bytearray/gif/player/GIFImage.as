package org.bytearray.gif.player
{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.net.URLRequest;
    
    import mx.controls.Image;
    import mx.core.UIComponent;
    
    import org.bytearray.gif.events.GIFPlayerEvent;

    public class GIFImage extends UIComponent
    {
        private var _player:GIFPlayer = null;
        private var _image:Image = null;
        private var _source:String = null;
        private var _child:DisplayObject = null;
        
        private function setChild(child:DisplayObject):void {
            if (_child === child) return;
            if (_child) removeChild(_child);
            addChild(child);
            _child = child;
        }

        public function get source ():String {
            return _source;
        }

        public function set source (src:String):void {
            if (_source === src) return;

            if (_player) {
                _player.stop();
                _player.bitmapData.dispose();
            }

            if (/\.gif$/i.test(src)) {
                if (!_player) {
                    _player = new GIFPlayer();
                    _player.addEventListener(GIFPlayerEvent.COMPLETE, onCompleteGIF);
                }
                setChild(_player);
                _player.load(new URLRequest(src));
            }
            else {
                if (!_image) {
                    _image = new Image();
                    _image.addEventListener(Event.COMPLETE, onCompleteImage);
                }
                setChild(_image);
                _image.source = src;
            }
            _source = src;
        }

        private function onCompleteImage(event:Event):void {
            this.width = _image.width = _image.contentWidth;
            this.height = _image.height = _image.contentHeight;
            this.invalidateSize();
            this.validateNow();
        }

        private function onCompleteGIF(event:GIFPlayerEvent):void {
            this.width = event.rect.width;
            this.height = event.rect.height;
            this.invalidateSize();
            this.validateNow();
            _player.play();
        }
    }
}