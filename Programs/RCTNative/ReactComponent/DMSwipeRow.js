'use strict';

import React, {
  Component,
  PropTypes
} from 'react';

import {
  Animated,
  PanResponder,
  Platform,
  StyleSheet,
  TouchableHighlight,
  TouchableOpacity,
  View
} from 'react-native';

const DIRECTIONAL_DISTANCE_CHANGE_THRESHOLD = 2;

class DMSwipeRow extends Component {
  constructor(props) {
    super(props);
    this.horizontalSwipeGestureBegan = false;
    this.swipeInitialX = null;
    this.parentScrollEnabled = true;
    this.state = {
      dimensionsSet:false,
      hiddenHeight:0,
      hiddenWidth:0,
      translateX:new Animated.Value(0)
    };
  }

  componentWillMount() {
    this._panResponder = PanResponder.create({
      onMoveShouldSetPanResponder:(e,gs) => this.handleOnMoveShouldSetPanResponder(e,gs),
      onPanResponderMove:(e,gs) => this.handleOnPanResponderMove(e,gs),
      onPanResponderRelease:(e,gs) => this.handleOnPanResponderEnd(e,gs),
      onPanResponderTerminate:(e,gs) => this.handleOnPanResponderEnd(e,gs),
      onShouldBlockNativeResponder:_ => false
    });
  }

  onContentLayout(e) {
    this.setState({
      dimensionsSet:!this.props.recalculateHiddenLayout,
      hiddenHeight:e.nativeEvent.layout.height,
      hiddenWidth:e.nativeEvent.layout.width
    });
  }

  onRowPress() {
    if (this.props.onRowPress) {
      this.props.onRowPress();
    }else{
      if (this.props.closeOnRowPress) {
        this.closeRow();
      }
    }
  }

  closeRow() {
    this.manuallySwipeRow(0);
  }

  manuallySwipeRow(toValue) {
    Animated.timing(this.state.translateX, {
      toValue,
      duration:300
      // friction:this.props.friction,
      // tension:this.props.tension
    }).start();

    if (toValue === 0) {
      this.props.onRowClose && this.props.onRowClose();
    }else {
      this.props.onRowOpen && this.props.onRowOpen();
    }

    this.swipeInitialX = null;
    this.horizontalSwipeGestureBegan = false;
  }

  renderVisibleContent() {
    const onPress = this.props.children[1].props.onPress;
    if (onPress) {
        const newOnPress = _ => {
          this.onRowPress();
          onPress();
        }
        return React.cloneElement(this.props.children[1],{
          ...this.props.children[1].props,
          onPress:newOnPress
        });
    }

    return (
      <TouchableOpacity
          activeOpacity={1}
          onPress={_ => this.onRowPress()}
      >
          {this.props.children[1]}
      </TouchableOpacity>
    );
  }

  renderRowContent() {
    if (this.state.dimensionsSet) {
        return (
          <Animated.View
              {...this._panResponder.panHandlers}
              style={{
                  transform:[
                    {translateX:this.state.translateX}
                  ]
              }}
          >
               {this.renderVisibleContent()}
          </Animated.View>
        );
    }else {
      return (
        <Animated.View
            {...this._panResponder.panHandlers}
            onLayout={ (e) => this.onContentLayout(e)}
            style={{
                transform:[
                  {translateX:this.state.translateX}
                ]
            }}
        >
            {this.renderVisibleContent()}
        </Animated.View>
      );
    }
  }

  render() {
    return (
        <View style={styles.container}>
            <View style={[
              styles.hidden,
              {
                  height:this.state.hiddenHeight,
                  width:this.state.hiddenWidth
              }
            ]}>
                {this.props.children[0]}
            </View>
            {this.renderRowContent()}
        </View>
    );
  }

  handleOnMoveShouldSetPanResponder(e,gs) {
      const { dx } = gs;
      return Math.abs(dx) > DIRECTIONAL_DISTANCE_CHANGE_THRESHOLD;
  }

  handleOnPanResponderMove(e,gs) {
      const { dx, dy } = gs;
      const absDx = Math.abs(dx);
      const absDy = Math.abs(dy);

      if (absDx > DIRECTIONAL_DISTANCE_CHANGE_THRESHOLD || absDy > DIRECTIONAL_DISTANCE_CHANGE_THRESHOLD) {
          if (absDy > absDx && !this.horizontalSwipeGestureBegan) {
              return;
          }

          if (this.parentScrollEnabled) {
              this.parentScrollEnabled = false;
              this.props.setScrollEnabled && this.props.setScrollEnabled(false);
          }

          if (this.swipeInitialX === null) {
              this.swipeInitialX = this.state.translateX._value;
          }
          this.horizontalSwipeGestureBegan = true;

          let newDX = this.swipeInitialX + dx;
          if (this.props.disableLeftSwipe && newDX < 0) {
              newDX = 0;
          }
          if (this.props.disableRightSwipe && newDX > 0) {
              newDX = 0;
          }

          this.setState({
            translateX: new Animated.Value(newDX)
          });
      }
  }

  handleOnPanResponderEnd(e,gs) {
      if (!this.parentScrollEnabled) {
          this.parentScrollEnabled = true;
          this.props.setScrollEnabled && this.props.setScrollEnabled(true);
      }

      let toValue = 0;
      if (this.state.translateX._value >= 0) {
          if (this.state.translateX._value > this.props.leftOpenValue / 2) {
             toValue = this.props.leftOpenValue;
          }
      }else {
          if (this.state.translateX._value < this.props.rightOpenValue / 2) {
             toValue = this.props.rightOpenValue;
          }
      }

      this.manuallySwipeRow(toValue);
  }
}

const styles = StyleSheet.create({
  container:{
    flex:1
  },
  hidden:{
    bottom:0,
    left:0,
    right:0,
    top:0,
    overflow:'hidden',
    position:'absolute'
  }
});

DMSwipeRow.propTypes = {
  setScrollEnabled:PropTypes.func,
  onRowOpen:PropTypes.func,
  onRowClose:PropTypes.func,

  leftOpenValue:PropTypes.number,
  rightOpenValue:PropTypes.number,
  friction:PropTypes.number,
  tension:PropTypes.number,

  closeOnRowPress:PropTypes.bool,
  disableLeftSwipe:PropTypes.bool,
  disableRightSwipe:PropTypes.bool,
  recalculateHiddenLayout:PropTypes.bool
};

DMSwipeRow.defaultProps = {
  leftOpenValue:0,
  rightOpenValue:0,
  closeOnRowPress:true,
  disableLeftSwipe:false,
  disableRightSwipe:false,
  recalculateHiddenLayout:false
};

export default DMSwipeRow;
