import { init, h } from 'snabbdom'
import snabbdom_class from 'snabbdom/es/modules/class'
import snabbdom_props from 'snabbdom/es/modules/props'
import snabbdom_style from 'snabbdom/es/modules/style'
import snabbdom_eventlisteners from 'snabbdom/es/modules/eventlisteners'

const patch = init([
	snabbdom_class,
	snabbdom_props,
	snabbdom_style,
	snabbdom_eventlisteners,
])

const root = document.querySelector('#root')
const view = h('h1', 'Hello world!')

patch(root, view)