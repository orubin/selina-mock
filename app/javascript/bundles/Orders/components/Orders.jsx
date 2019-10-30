import React from 'react';
import axios from 'axios';
import './Orders.css';
import DatePicker from "react-datepicker";
import BookRoomForm from './BookRoomForm';
 
import "react-datepicker/dist/react-datepicker.css";

const Room = (props) => {
  if (props.name === '' || props.price === '') {
    return ('');
  }
  return (
    <div>
      <table className="roomtable">
        <tbody>
          <tr>
            <td className="tableCell">{props.name}</td>
            <td className="tableCell">{props.price}</td>
            <td className="tableCell">{props.capacity}</td>
            <td className="tableCell"><button onClick={props.onClick}>Book now</button></td>
          </tr>
        </tbody>
      </table>
    </div>
  );
}

export default class Orders extends React.Component {
  /**
   * @param props
   */
  constructor(props) {
    super(props);

    this.state = { 
      rooms: [],
      startDate: new Date(),
      endDate: new Date(),
      days: 0,
    };
    this.name = this.props.name;
    this.location_id = this.props.location_id;
  }

  calculateDateDiff(startDate, endDate) {
    let msDiff = endDate - startDate;
    let days = Math.floor(msDiff / (1000 * 60 * 60 * 24));
    this.setState({
      days: days + 1
    });
  }

  handleChangeStart = date => {
    this.setState({
      startDate: date
    });
    this.calculateDateDiff(date, this.state.endDate);
  };
  handleChangeEnd = date => {
    this.setState({
      endDate: date
    });
    this.calculateDateDiff(this.state.startDate, date);
  };

  checkRooms() {
    const csrfToken = ReactOnRails.authenticityToken();
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': csrfToken
      }
    };

    const data = { start_date: this.state.startDate, end_date: this.state.endDate, location_id: this.location_id };

    axios.post('/api/v1/check_rooms', data, config).then((response) => {
      if (response.data) {
        this.setState({ rooms: response.data.data });
      }
    });
  }

  bookRoom(room) {
    // clear the view
    this.setState( {rooms: [], chosenRoom: room} );
  }

  render() {
    return (
      <div className="container">
        <h2>Stay at {this.props.name}</h2>
        Check in
        <DatePicker
          className="datePicker"
          selected={this.state.startDate}
          onChange={this.handleChangeStart}
        />
        
        Check out
        <DatePicker
          className="datePicker"
          selected={this.state.endDate}
          onChange={this.handleChangeEnd}
        />

        <button onClick={() => this.checkRooms()}>Check Rooms</button>

        <hr />

        <ul>
          {this.state.rooms.map((room, key) => 
            <Room key={room.name} name={room.name} price={room.price} capacity={room.capacity} onClick={() => this.bookRoom(room)}/>
          )}
        </ul>

        <BookRoomForm 
          room={this.state.chosenRoom}
          startDate={this.state.startDate}
          endDate={this.state.endDate}
          days={this.state.days}
          location_id={this.location_id}
          />
        
      </div>
    );
  }
}
