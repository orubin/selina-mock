import React from 'react';
import axios from 'axios';
import './BookRoomForm.css';

const Price = (props) => {
    if (props.days <= 0) {
      return ('');
    }
    return (
      <h4>Price for {props.days} nights: {props.days * props.price} $</h4>
    );
  }

export default class BookRoomForm extends React.Component {
    constructor(props) {
        super(props);
        this.props = props;
        this.state = {days: props.days, message: ''};
    }
    
    submitForm = (e) => {
        e.preventDefault();
        
        const data = {
            name: e.target.name.value,
            address: e.target.address.value,
            phone: e.target.phone.value,
            email: e.target.email.value,
            price: this.props.room.price,
            room_type: this.props.room.name,
            start_date: this.props.startDate,
            end_date: this.props.endDate,
            location_id: this.props.location_id
        };

        const config = {
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRF-Token': ReactOnRails.authenticityToken()
          }
        };
        
        axios.post('/api/v1/book_room', data, config).then((response) => {
          this.setState({message: response.data.message});
        });
    }
    
      render () {
        if (!this.props.room) {
          return ('');
        }
        return (<div>
          <h3>Book room of type {this.props.room.name}</h3>
          <form onSubmit={(e) => this.submitForm(e)}>
            <div className="form-group">
              <label htmlFor="name">Name</label>
              <input className="form-control" type="text" id="name" required/>
            </div>
            <div className="form-group">
              <label htmlFor="address">Address</label>
              <input className="form-control" type="text" id="address" required/>
            </div>
            <div className="form-group">
              <label htmlFor="phone">Phone</label>
              <input className="form-control" type="text" id="phone" required/>
            </div>
            <div className="form-group">
              <label htmlFor="email">Email</label>
              <input className="form-control" type="text" id="email" required/>
            </div>
            <div className="form-group">
              <button className="btn btn-primary" type="submit">Submit</button>
            </div>
          </form>
          <Price days={this.props.days} price={this.props.room.price} />
          <h2>{this.state.message}</h2>
        </div>);
      }
}