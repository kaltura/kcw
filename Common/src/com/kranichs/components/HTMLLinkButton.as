package com.kranichs.components
{
    import mx.controls.LinkButton;

    public class HTMLLinkButton extends LinkButton
    {
        protected var _isHTML:Boolean;

        public function HTMLLinkButton()
        {
                super();
        }

        [Bindable]
        public function set isHTML(value:Boolean):void
        {
                _isHTML = value;
        }
        public function get isHTML():Boolean
        {
                return _isHTML;
        }

        override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if(_isHTML)
            {
                textField.htmlText = label;
            }
        }
    }
}