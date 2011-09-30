(function($) {
  $.widget("ui.surveySortable", $.extend({}, $.ui.sortable.prototype, {
    options: {
    },

    _create: function(){
      this.element.data('sortable', this.element.data('surveySortable'));
      return $.ui.sortable.prototype._create.apply(this, arguments);
    },

    _mouseDrag: function(event) {
      this.position = this._generatePosition(event);
      this.positionAbs = this._convertPositionTo("absolute");

      if(!this.lastPositionAbs) {
        this.lastPositionAbs = this.positionAbs;
      }
      
      if(this.options.scroll) {
        var o = this.options, scrolled = false;
        if(this.scrollParent[0] != document && this.scrollParent[0].tagName != 'HTML') {
          if((this.overflowOffset.top + this.scrollParent[0].offsetHeight) - event.pageY < o.scrollSensitivity)
            this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop + o.scrollSpeed;
          else if(event.pageY - this.overflowOffset.top < o.scrollSensitivity)
            this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop - o.scrollSpeed;

          if((this.overflowOffset.left + this.scrollParent[0].offsetWidth) - event.pageX < o.scrollSensitivity)
            this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft + o.scrollSpeed;
          else if(event.pageX - this.overflowOffset.left < o.scrollSensitivity)
            this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft - o.scrollSpeed;
        } else {
          if(event.pageY - $(document).scrollTop() < o.scrollSensitivity)
            scrolled = $(document).scrollTop($(document).scrollTop() - o.scrollSpeed);
          else if($(window).height() - (event.pageY - $(document).scrollTop()) < o.scrollSensitivity)
            scrolled = $(document).scrollTop($(document).scrollTop() + o.scrollSpeed);

          if(event.pageX - $(document).scrollLeft() < o.scrollSensitivity)
            scrolled = $(document).scrollLeft($(document).scrollLeft() - o.scrollSpeed);
          else if($(window).width() - (event.pageX - $(document).scrollLeft()) < o.scrollSensitivity)
            scrolled = $(document).scrollLeft($(document).scrollLeft() + o.scrollSpeed);
        }

        if(scrolled !== false && $.ui.ddmanager && !o.dropBehaviour) {
          $.ui.ddmanager.prepareOffsets(this, event);
        }
      }

      this.positionAbs = this._convertPositionTo("absolute");

      if(!this.options.axis || this.options.axis != "y") {
        this.helper[0].style.left = this.position.left + 'px';
      }
      if(!this.options.axis || this.options.axis != "x") {
        this.helper[0].style.top = this.position.top + 'px';
      }
      
      for(var i = this.items.length - 1; i >= 0; i--) {
        var item = this.items[i], itemElement = item.item[0], intersection = this._intersectsWithPointer(item);
        if(!intersection) continue;

        if(itemElement != this.currentItem[0] // cannot intersect with itself
        && this.placeholder[intersection == 1 ? "next" : "prev"]()[0] != itemElement // no useless actions that have been done before
        && !$.contains(this.placeholder[0], itemElement) // no action if the item moved is the parent of the item checked
        && (this.options.type == 'semi-dynamic' ? !$.contains(this.element[0], itemElement) : true)) {
          this.direction = intersection == 1 ? "down" : "up";

          if(this.options.tolerance == "pointer" || this._intersectsWithSides(item)) {
            this._rearrange(event, item);
          } else {
            break;
          }

          this._clearEmpty(itemElement);

          this._trigger("change", event, this._uiHash());
          break;
        }
      }

      var parentItem = (this.placeholder[0].parentNode.parentNode && $(this.placeholder[0].parentNode.parentNode).closest('.ui-sortable').length) ? $(this.placeholder[0].parentNode.parentNode) : null;
      var previousItem = this.placeholder[0].previousSibling ? $(this.placeholder[0].previousSibling) : null;
      if(previousItem != null) {
        while(previousItem[0].nodeName.toLowerCase() != 'li' || previousItem[0] == this.currentItem[0]) {
          if(previousItem[0].previousSibling) {
            previousItem = $(previousItem[0].previousSibling);
          } else {
            previousItem = null;
            break;
          }
        }
      }
    
      if(previousItem != null && !previousItem.hasClass('survey_question')) {
        if(previousItem[0].children[1] == null) {
          $(previousItem[0]).append('<ol id="nested-questions-' + $(previousItem[0]).attr('data-choice-id') + '"></ol>');
        }
        previousItem[0].children[1].appendChild(this.placeholder[0]);
        this._trigger("change", event, this._uiHash());
      } else if(parentItem != null && !parentItem.hasClass('survey_question_choice')) {
        parentItem.after(this.placeholder[0]);
        this._clearEmpty(parentItem[0]);
        this._trigger("change", event, this._uiHash());
      }

      this._contactContainers(event);

      if($.ui.ddmanager) {
        $.ui.ddmanager.drag(this, event);
      }

      this._trigger('sort', event, this._uiHash());
      
      this.lastPositionAbs = this.positionAbs;
      return false;
    },

    _mouseStop: function(event, noPropagation) {
      $.ui.sortable.prototype._mouseStop.apply(this, arguments);
    },

    _clearEmpty: function(item) {
      if(item.children[1] && item.children[1].children.length == 0) {
        item.removeChild(item.children[1]);
      }
    },

    serialize: function(o) {
      var items = this._getItemsAsjQuery(o && o.connected);
      var str = []; o = o || {};

      $(items).each(function() {
        var res = ($(o.item || this).attr(o.attribute || 'id') || '').match(o.expression || (/(.+)[-=_](.+)/));
        var pid = ($(o.item || this).parent(o.listType).parent('li').attr(o.attribute || 'id') || '').match(o.expression || (/(.+)[-=_](.+)/));
        if(res) str.push((o.key || res[1]+'['+(o.key && o.expression ? res[1] : res[2])+']')+'='+(pid ? (o.key && o.expression ? pid[1] : pid[2]) : 'root'));
      });

      if(!str.length && o.key) {
        str.push(o.key + '=');
      }

      return str.join('&');
    },

    toHierarchy: function(o) {
      o = o || {};
      var sDepth = o.startDepthCount || 0;
      var ret = [];

      $(this.element).children('li').each(function() {
        var level = _recursiveItems($(this));
        ret.push(level);
      });

      return ret;

      function _recursiveItems(li) {
        var id = ($(li).attr(o.attribute || 'id') || '').match(o.expression || (/(.+)[-=_](.+)/));
        if(id != null) {
          var item = {"id" : id[2]};
          if($(li).children(o.listType).children('li').length > 0) {
            item.children = [];
            $(li).children(o.listType).children('li').each(function() {
              var level = _recursiveItems($(this));
              item.children.push(level);
            });
          }
          return item;
        }
      }
    },

    toArray: function(o) {
      o = o || {};
      var sDepth = o.startDepthCount || 0;
      var ret = [];
      var left = 2;

      ret.push({"item_id": 'root', "parent_id": 'none', "depth": sDepth, "left": '1', "right": ($('li', this.element).length + 1) * 2});

      $(this.element).children('li').each(function() {
        left = _recursiveArray(this, sDepth + 1, left);
      });

      function _sortByLeft(a,b) {
        return a['left'] - b['left'];
      }
      ret = ret.sort(_sortByLeft);

      return ret;

      function _recursiveArray(item, depth, left) {
        right = left + 1;

        if($(item).children(o.listType).children('li').length > 0) {
          depth ++;
          $(item).children(o.listType).children('li').each(function() {
            right = _recursiveArray($(this), depth, right);
          });
          depth --;
        }

        id = ($(item).attr(o.attribute || 'id')).match(o.expression || (/(.+)[-=_](.+)/));

        if(depth === sDepth + 1) {
          pid = 'root';
        } else {
          parentItem = ($(item).parent(o.listType).parent('li').attr('id')).match(o.expression || (/(.+)[-=_](.+)/));
          pid = parentItem[2];
        }

        if(id != null) {
          ret.push({"item_id": id[2], "parent_id": pid, "depth": depth, "left": left, "right": right});
        }

        return left = right + 1;
      }
    }

  }));
  $.ui.surveySortable.prototype.options = $.extend({}, $.ui.sortable.prototype.options, $.ui.surveySortable.prototype.options);
})(jQuery);