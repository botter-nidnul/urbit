import React, { Component } from 'react';
import classnames from 'classnames';

import { Text }       from '/components/lib/text';
import { Button }     from '/components/lib/button';
import { Form }       from '/components/lib/form';
import { TextInput }  from '/components/lib/text-input';
import { Submit }     from '/components/lib/submit';
import { Size }       from '/components/lib/size';
import { Padding }    from '/components/lib/padding';
import { Horizontal } from '/components/lib/horizontal';
import { Vertical }   from '/components/lib/vertical';

export class Dom extends Component {
  constructor(props) {
    super(props);
    this.parseDom = this.parseDom.bind(this);
  }

  parseDom(dom) {
    let head = Object.keys(dom)[0];
    let body = Object.values(dom)[0];
    switch (head) {
      case "text":
        return (
          <Text body={body}/>
        );
      case "button":
        return (
          <Button body={body.body} action={body.action} api={this.props.api}/>
        );
      case "form":
        return (
          <Form app={body.app}
            mark={body.mark}
            body={body.body}
            data={body.data}
            api={this.props.api}/>
        );
      case "text-input":
        return (
          <TextInput name={body.name}/>
        );
      case "submit":
        return (
          <Submit body={body} api={this.props.api}/>
        );
      case "size":
        return (
          <Size width={body.width}
                height={body.height}
                api={this.props.api}
                body={body.body}/> 
        );
      case "padding":
        return (
          <Padding top={body.top}
                bottom={body.bottom}
                left={body.left}
                right={body.right}
                api={this.props.api}
                body={body.body}/> 
        );
      case "horizontal":
        return (
          <Horizontal body={body} api={this.props.api}/>
        );
      case "vertical":
        return (
          <Vertical body={body} api={this.props.api}/>
        );
      default:
        return;
    }
  }

  render() {
    if (this.props.body === null) {
       return null;
    } else {
      return this.parseDom(this.props.body);
    }
  }
}