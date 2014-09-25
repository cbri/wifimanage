/*
 *   SmallSilder
 *
 */ 
(function ($) {
    $.smallslider = function (elm, options) {
        var _this = this;
        _this.elm = elm; 
        _this.$elm = $(elm); 
        _this.opts = $.extend({}, $.smallslider.defaults, options);
        _this.sliderTimer = null;

        _this.init = function () {
            _this.itemNums = _this.$elm.find('.sliderItem').length;
            _this.$item = _this.$elm.find('.sliderItem');
            _this.$navi = _this.$elm.find('div#sliderNaviList'); 
            _this.$prev   = _this.$elm.find('a#sliderToPrev');
            _this.$next   = _this.$elm.find('a#sliderToNext');
            _this.current = 0;
            _this.nawidth = 0; 
            // position
            _this.$elm.css({width:_this.opts.width,height:_this.opts.height});
            _this.$prev.css({top:(Math.ceil((_this.opts.height-120)/2)),width:_this.opts.scale*60,height:_this.opts.scale*120,'background-size':_this.opts.scale*58+'px '+_this.opts.scale*120+'px'});
            _this.$next.css({top:(Math.ceil((_this.opts.height-120)/2)),width:_this.opts.scale*60,height:_this.opts.scale*120,'background-size':_this.opts.scale*58+'px '+_this.opts.scale*120+'px'});
            
            _this.$navi.html('');
            for(var i=0;i<_this.itemNums;i++){
            	_this.$navi.append('<a href="javascript:;">&nbsp;</a>');
            	_this.nawidth +=21;
            }
            
            _this.$elm.find('.sliderNavigator').css({width:_this.nawidth+20,left:((_this.opts.width-_this.nawidth)/2)});
            _this.$active = _this.$elm.find('div#sliderNaviList a');
            _this.$item.fadeOut(0).eq(0).fadeIn(_this.opts.switchTime);
            _this.$active.removeClass('active').eq(0).addClass('active');
            _this.startSlider(1);
            _this.clickTo();
        };

        _this.slideTo = function (index) {
            _this.stopSlider(); 
            if (index > _this.itemNums - 1) index = 0;
            if (index < 0) index = _this.itemNums - 1;

            _this.$item.fadeOut(_this.opts.switchTime).eq(index).fadeIn(_this.opts.switchTime);
            _this.$active.removeClass('active').eq(index).addClass('active');
            _this.current = index;
            _this.startSlider(index + 1);
        };

        _this.startSlider = function (index) {
            var st = setTimeout(function () {
                _this.slideTo(index);
            }, _this.opts.time);
            _this.sliderTimer = st;
        };

        _this.stopSlider = function () {
            if (_this.sliderTimer) {
                clearTimeout(_this.sliderTimer);
            }
            _this.sliderTimer = null;
        };
        
        _this.clickTo = function(){
        	_this.$prev.click(function(){
        		_this.$item.stop();
        		_this.slideTo(_this.current-1);
        	});
        	_this.$next.click(function(){
        		_this.$item.stop();
        		_this.slideTo(_this.current+1);
        	});
        	_this.$active.click(function(){
        		_this.$item.stop();
        		_this.slideTo($(this).prevAll().length);
        	})
        }

        _this.init();
    };

    $.smallslider.defaults = {
        time: 5000,
        switchTime: 500,
        width:800,
        height:480,
        scale:1
    };

    $.fn.smallslider = function (options) {
        return this.each(function (i) {
            (new $.smallslider(this, options));
        });
    };

})(jQuery);


(function ($) {
    $.loadOverly = function (elm, options) {
        var _this = this;
        _this.elm = elm; 
        _this.$elm = $(elm); 
        _this.opts = $.extend({}, $.loadOverly.defaults, options);
        _this.overlyTimer = null;
        _this.textTimer = null;
        _this.time = null;

        _this.init = function () {
        	_this.$text = _this.$elm.find('div#loadingTimeText');
        	_this.$back = _this.$elm.find('div.loadingTimeTip');
        	_this.time  = _this.opts.time;
            _this.$elm.fadeIn(0);
            _this.startLoader();
        };

        _this.startLoader = function(){
        	var width = _this.$elm.width();
        	
        	_this.stopLoad();
        	_this.$back.css({top:10,left:(width-180)/2});
        	_this.$text.html('再有'+_this.time+'秒，惊喜即将为你呈现...');
        	_this.time = _this.time -1;
        	if(_this.time>-1){
        		_this.overlyTime = setTimeout(_this.startLoader, 1000);
        	}else{
        		_this.overlyTime = setTimeout(function(){
        			_this.$elm.fadeOut(500);
        			_this.stopLoad();
        		}, 1000);
        	}
        }
        
        _this.stopLoad = function(){
        	if(_this.overlyTimer) clearTimeout(_this.overlyTimer);
        	_this.overlyTimer = null;
        }

        _this.init();
    };

    $.loadOverly.defaults = {
        time: 5,
        editmode: false
    };

    $.fn.loadOverly = function (options) {
        return this.each(function (i) {
            (new $.loadOverly(this, options));
        });
    };

})(jQuery);
