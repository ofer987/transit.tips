import * as React from 'react';

export interface ILoadingProps {
}

export class LoadingComponent extends React.Component<ILoadingProps, Object> {
  constructor(props: ILoadingProps, context) {
    super(props, context);
  }

  render() {
    return (
      <div>
        <h1 id='url'>Transit.Tips</h1>
        <h2 id='welcome'>Searching for nearest transit information</h2>
      </div>
    )
  }
}
