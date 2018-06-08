import { fetchCartLink } from './cart';

export default function SpreeFrontendRails() {
  window.Spree.fetch_cart = fetchCartLink
  return
}
