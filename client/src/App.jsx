import './App.css';
import { Routes, Route } from 'react-router-dom';
import Login from './pages/Login';
import IndexPage from './pages/IndexPage';
import Layout from './Layout';
import Register from './pages/Register';
import axios from 'axios';

axios.defaults.baseURL = 'http://localhost:6060';

function App() {
  return (
    <Routes>
      <Route path='/' element={<Layout/>}>
        <Route index element={<IndexPage/>} />
        <Route path="/login" element={<Login/>} />
        <Route path="/register" element={<Register/>} />
      </Route>
    </Routes>
    
  );
}

export default App;
